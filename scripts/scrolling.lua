local policy = require("scripts.monitor_policy")
local M = {}

local function ordered_tiled_windows(ws)
    local portrait = policy.is_portrait(ws.monitor)

    local tiled = {}
    for _, w in ipairs(hl.get_workspace_windows(ws.id)) do
        if not w.floating and w.mapped then tiled[#tiled + 1] = w end
    end
    table.sort(tiled, function(a, b)
        local a1, a2, b1, b2 = a.at.x, a.at.y, b.at.x, b.at.y
        if portrait then a1, a2, b1, b2 = a2, a1, b2, b1 end
        if a1 ~= b1 then return a1 < b1 end
        if a2 ~= b2 then return a2 < b2 end
        return a.address < b.address
    end)
    return tiled
end

function M.wheel_focus(dir)
    local ws = hl.get_active_workspace()
    if not ws then return end

    if ws.tiled_layout ~= "scrolling" then
        hl.dispatch(hl.dsp.window.cycle_next({ [dir == "up" and "prev" or "next"] = true }))
        return
    end

    local tiled = ordered_tiled_windows(ws)
    local cur = hl.get_active_window()
    local curaddr = cur and cur.address
    local idx
    for i, w in ipairs(tiled) do
        if w.address == curaddr then
            idx = i; break
        end
    end
    if not idx then return end

    local target = dir == "up" and idx + 1 or idx - 1
    if target < 1 or target > #tiled then return end
    hl.dispatch(hl.dsp.focus({ window = "address:" .. tiled[target].address }))
end

local PRESETS = { policy.portrait_width, policy.landscape_width, 0.75, 1.0 }

local PRESET_EPSILON = 0.02
local MAXIMIZED = PRESETS[#PRESETS] - PRESET_EPSILON

local restore_width = {}
local last_width = {}
local pending = {}

local function scrolling_target()
    local ws = hl.get_active_workspace()
    local win = ws and hl.get_active_window()
    if not ws or not win or ws.tiled_layout ~= "scrolling" or win.floating then return end

    local ew, eh = policy.size(ws.monitor)
    local portrait = eh > ew
    local span = portrait and eh or ew
    local size = portrait and win.size.y or win.size.x
    return win, size / span, portrait
end

local function colresize(fraction)
    local win = scrolling_target()
    if not win then return end

    hl.dispatch(hl.dsp.layout(string.format("colresize %.3f", fraction)))

    last_width[win.address] = { fraction = fraction, monitor = win.monitor and win.monitor.name }
end

local function snap(fraction)
    for _, preset in ipairs(PRESETS) do
        if math.abs(preset - fraction) <= PRESET_EPSILON then return preset end
    end
    return fraction
end

function M.col_step(direction, wrap)
    local win, fraction = scrolling_target()
    if not win then return end

    local target
    if direction == "up" then
        for i = 1, #PRESETS do
            if PRESETS[i] > fraction + PRESET_EPSILON then
                target = i
                break
            end
        end
        if not target and wrap then target = 1 end
    else
        for i = #PRESETS, 1, -1 do
            if PRESETS[i] < fraction - PRESET_EPSILON then
                target = i
                break
            end
        end
        if not target and wrap then target = #PRESETS end
    end

    if target then colresize(PRESETS[target]) end
end

local APPLY_RETRIES = 4
local APPLY_INTERVAL = 40

local function apply_after_move(address, fraction, from, attempt)
    attempt = attempt or 0
    local after = hl.get_active_window()

    if not after or after.address ~= address then
        if attempt < APPLY_RETRIES then
            hl.timer(function() apply_after_move(address, fraction, from, attempt + 1) end,
                { timeout = APPLY_INTERVAL, type = "oneshot" })
        else
            pending[address] = { fraction = fraction, from = from }
        end
        return
    end

    local to = after.monitor and after.monitor.name
    if not to then return end

    if to == from then
        colresize(snap(fraction))
    elseif policy.monitor_widths[to] then

        colresize(policy.monitor_widths[to])
    end
end

function M.preserve_width(move)
    local before, fraction = scrolling_target()
    local from = before and before.monitor and before.monitor.name

    move()

    if before and from then apply_after_move(before.address, fraction, from) end
end

local function apply_pending(address)
    local held = pending[address]
    if not held then return end
    pending[address] = nil
    apply_after_move(address, held.fraction, held.from)
end

hl.on("window.active", function(win)
    if win and win.address and pending[win.address] then
        apply_pending(win.address)
    end
end)

hl.on("window.move_to_workspace", function(win)
    if not win or not win.address then return end
    local address = win.address
    local cached = last_width[address]
    if not cached or not cached.monitor then return end

    pending[address] = { fraction = cached.fraction, from = cached.monitor }
    hl.timer(function() apply_pending(address) end, { timeout = 60, type = "oneshot" })
end)

function M.col_maximize()
    local ws = hl.get_active_workspace()
    if ws and ws.tiled_layout == "dwindle" then
        if hl.get_active_window() then
            hl.dispatch(hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
        end
        return
    end

    local win, fraction, portrait = scrolling_target()
    if not win then return end

    local live = {}
    for _, w in ipairs(hl.get_windows()) do live[w.address] = true end
    for address in pairs(restore_width) do
        if not live[address] then restore_width[address] = nil end
    end
    for address in pairs(last_width) do
        if not live[address] then last_width[address] = nil end
    end

    if fraction >= MAXIMIZED then
        local width = restore_width[win.address]
        restore_width[win.address] = nil
        colresize(width or policy.column_width(portrait))
        return
    end

    restore_width[win.address] = snap(fraction)
    colresize(PRESETS[#PRESETS])
end

function M.col_set(fraction)
    local win = scrolling_target()
    if not win then return end
    colresize(fraction)
end

function M.toggle_layout()
    local ws = hl.get_active_workspace()
    if not ws then return end
    local id = tostring(ws.id)
    if ws.tiled_layout == "scrolling" then
        hl.workspace_rule({ workspace = id, layout = "dwindle" })
    else
        local portrait = policy.is_portrait(ws.monitor)
        local dir = portrait and "down" or "right"
        local cw = policy.column_width(portrait)
        hl.config({ scrolling = { column_width = cw } })
        hl.workspace_rule({ workspace = id, layout = "scrolling", layout_opts = { direction = dir } })
        hl.timer(function() hl.config({ scrolling = { column_width = policy.portrait_width } }) end,
            { timeout = 100, type = "oneshot" })
    end
    hl.config({ general = { layout = "dwindle" } })
end

function M.move_flow(dir)
    local ws = hl.get_active_workspace()
    if not ws then return end
    local cur = hl.get_active_window()
    if not cur or cur.floating then return end

    local portrait = policy.is_portrait(ws.monitor)

    if ws.tiled_layout == "dwindle" then
        local tiled = ordered_tiled_windows(ws)
        for i, win in ipairs(tiled) do
            if win.address == cur.address then
                local target = tiled[dir == "back" and i - 1 or i + 1]
                if target then
                    hl.dispatch(hl.dsp.window.swap({ target = "address:" .. target.address }))
                end
                break
            end
        end
        return
    end
    if ws.tiled_layout ~= "scrolling" then return end

    local primary, secondary, anti_primary
    if dir == "back" then
        primary, secondary, anti_primary = portrait and "l" or "u", portrait and "u" or "l", portrait and "r" or "d"
    else
        primary, secondary, anti_primary = portrait and "r" or "d", portrait and "d" or "r", portrait and "l" or "u"
    end
    local function cross(w) return portrait and w.at.x or w.at.y end
    local function tape(w) return portrait and w.at.y or w.at.x end

    local tiled, seg, t = {}, {}, tape(cur)
    for _, w in ipairs(hl.get_workspace_windows(ws.id)) do
        if not w.floating and w.mapped then
            tiled[#tiled + 1] = w
            if math.abs(tape(w) - t) < 10 then seg[#seg + 1] = w end
        end
    end
    table.sort(seg, function(a, b) return cross(a) < cross(b) end)
    local idx
    for i, w in ipairs(seg) do
        if w.address == cur.address then idx = i; break end
    end
    if not idx then return end

    local at_edge
    if dir == "back" then at_edge = idx == 1 else at_edge = idx == #seg end
    if not at_edge then
        hl.dispatch(hl.dsp.window.move({ direction = primary }))
        return
    end

    if #seg > 1 then
        hl.dispatch(hl.dsp.layout(dir == "back" and "consume_or_expel prev" or "consume_or_expel next"))
        colresize(policy.column_width(portrait))
        return
    end

    local next_tape
    for _, w in ipairs(tiled) do
        local wt = tape(w)
        if dir == "back" then
            if wt < t - 10 and (not next_tape or wt > next_tape) then next_tape = wt end
        else
            if wt > t + 10 and (not next_tape or wt < next_tape) then next_tape = wt end
        end
    end
    if not next_tape then return end

    hl.dispatch(hl.dsp.window.move({ direction = secondary }))
    for _ = 1, 32 do
        local ws2 = hl.get_active_workspace()
        if not ws2 then break end
        local list = hl.get_workspace_windows(ws2.id)
        local mt, mc
        for _, w in ipairs(list) do
            if w.address == cur.address then mt, mc = tape(w), cross(w); break end
        end
        if not mt then break end
        local beyond = 0
        for _, w in ipairs(list) do
            if not w.floating and w.mapped and math.abs(tape(w) - mt) < 10 then
                if (dir == "back" and cross(w) > mc) or (dir ~= "back" and cross(w) < mc) then
                    beyond = beyond + 1
                end
            end
        end
        if beyond == 0 then break end
        hl.dispatch(hl.dsp.window.move({ direction = anti_primary }))
    end
end

return M
