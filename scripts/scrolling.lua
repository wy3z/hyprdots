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


function M.col_toggle(lo, hi)
    local ws = hl.get_active_workspace()
    local cur = ws and hl.get_active_window()
    if not ws or not cur or ws.tiled_layout ~= "scrolling" or cur.floating then return end

    local ew, eh = monitor_size(ws.monitor)
    local portrait = eh > ew
    local span = portrait and eh or ew
    local size = portrait and cur.size.y or cur.size.x

    -- Account for gaps and borders by comparing against the midpoint.
    local target = (size / span >= (lo + hi) / 2) and lo or hi
    hl.dispatch(hl.dsp.layout(string.format("colresize %.3f", target)))
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
    -- Re-read after each move because the layout updates immediately.
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
