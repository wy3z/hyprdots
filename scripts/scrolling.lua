local M = {}

local function monitor_size(mon)
    local width, height = mon.width, mon.height
    if mon.transform % 2 == 1 then width, height = height, width end
    return width, height
end


function M.wheel_focus(dir)
    local ws = hl.get_active_workspace()
    if not ws then return end

    if ws.tiled_layout ~= "scrolling" then
        hl.dispatch(hl.dsp.window.cycle_next({ [dir == "up" and "prev" or "next"] = true }))
        return
    end

    local ew, eh = monitor_size(ws.monitor)
    local portrait = eh > ew

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


function M.default_col_width(portrait)
    return portrait and 0.333 or 0.5
end


local PRESETS = { 0.333, 0.5, 0.75, 1.0 }

local PRESET_EPSILON = 0.02 -- measured width is under the nominal preset
local MAXIMIZED = PRESETS[#PRESETS] - PRESET_EPSILON

local restore_width = {}
local last_width = {}
local pending = {}

local function scrolling_target()
    local ws = hl.get_active_workspace()
    local win = ws and hl.get_active_window()
    if not ws or not win or ws.tiled_layout ~= "scrolling" or win.floating then return end

    local ew, eh = monitor_size(ws.monitor)
    local portrait = eh > ew
    local span = portrait and eh or ew
    local size = portrait and win.size.y or win.size.x
    return win, size / span, portrait
end

local function colresize(fraction)
    hl.dispatch(hl.dsp.layout(string.format("colresize %.3f", fraction)))

    local win = hl.get_active_window()
    if win then
        last_width[win.address] = { fraction = fraction, monitor = win.monitor and win.monitor.name }
    end
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

-- window_rules scrolling_width is map-time only; this is for later moves.
local MONITOR_WIDTH = {
    ["DP-2"] = 0.5,
    ["HDMI-A-1"] = 0.333,
}

-- TEMPORARY DIAGNOSTIC, remove once dragging is understood.
local function dbg(line)
    local f = io.open("/tmp/dragdbg", "a")
    if not f then return end
    f:write(line .. "\n")
    f:close()
end

local APPLY_RETRIES = 4
local APPLY_INTERVAL = 40

local function apply_after_move(address, fraction, from, attempt)
    attempt = attempt or 0
    local after = hl.get_active_window()
    dbg(string.format("  apply[%d]: want=%s active=%s from=%s to=%s frac=%.3f",
        attempt, tostring(address), tostring(after and after.address), tostring(from),
        tostring(after and after.monitor and after.monitor.name), fraction or -1))

    if not after or after.address ~= address then
        if attempt < APPLY_RETRIES then
            hl.timer(function() apply_after_move(address, fraction, from, attempt + 1) end,
                { timeout = APPLY_INTERVAL, type = "oneshot" })
        else
            dbg("  apply: holding for next focus")
            pending[address] = { fraction = fraction, from = from }
        end
        return
    end

    local to = after.monitor and after.monitor.name
    if not to then return end

    if to == from then
        dbg("  apply: same monitor, restoring " .. tostring(snap(fraction)))
        colresize(snap(fraction))
    elseif MONITOR_WIDTH[to] then
        dbg("  apply: crossed to " .. to .. ", setting " .. MONITOR_WIDTH[to])
        colresize(MONITOR_WIDTH[to])
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

for _, sub in ipairs(_G.__probe_subs or {}) do sub:remove() end
_G.__probe_subs = {}
for _, name in ipairs({
    "window.update_rules", "window.title", "window.pin", "window.fullscreen",
    "workspace.active", "window.open", "window.urgent", "window.class",
}) do
    table.insert(_G.__probe_subs, hl.on(name, function(a)
        local w = hl.get_active_window()
        dbg(string.format("EVENT %s | arg=%s | active=%s size=%s", name,
            tostring(a and (type(a) == "userdata" and a.address or a)),
            tostring(w and w.class), tostring(w and w.size and w.size.x)))
    end))
end

for _, sub in ipairs(_G.__scrolling_subs or {}) do sub:remove() end
_G.__scrolling_subs = {
    hl.on("window.active", function(win)
        local w, frac = scrolling_target()
        dbg(string.format("EVENT window.active | %s frac=%s", tostring(w and w.class),
            frac and string.format("%.3f", frac) or "nil"))
        if win and win.address and pending[win.address] then
            dbg("active: applying held width for " .. tostring(win.address))
            apply_pending(win.address)
        end
    end),

    hl.on("window.move_to_workspace", function(win)
        if not win or not win.address then return end
        local address = win.address
        local cached = last_width[address]
        dbg(string.format("moved: %s cached=%s", tostring(address), tostring(cached ~= nil)))
        if not cached or not cached.monitor then return end

        pending[address] = { fraction = cached.fraction, from = cached.monitor }
        hl.timer(function() apply_pending(address) end, { timeout = 60, type = "oneshot" })
    end),
}

function M.col_maximize()
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
        colresize(width or M.default_col_width(portrait))
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
        hl.config({ general = { layout = "dwindle" } })
    else
        local ew, eh = monitor_size(ws.monitor)
        local dir, cw = "right", 0.5
        if eh > ew then dir, cw = "down", 0.333 end
        hl.config({ scrolling = { column_width = cw } })
        hl.workspace_rule({ workspace = id, layout = "scrolling", layout_opts = { direction = dir } })
        hl.config({ general = { layout = "dwindle" } })
        hl.timer(function() hl.config({ scrolling = { column_width = 0.333 } }) end,
            { timeout = 100, type = "oneshot" })
    end
end


function M.move_flow(dir)
    local ws = hl.get_active_workspace()
    if not ws or ws.tiled_layout ~= "scrolling" then return end
    local cur = hl.get_active_window()
    if not cur then return end

    local ew, eh = monitor_size(ws.monitor)
    local portrait = eh > ew

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
        hl.dispatch(hl.dsp.layout(string.format("colresize %.3f", M.default_col_width(portrait))))
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
