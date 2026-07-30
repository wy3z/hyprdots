-- =====================================================================
-- Scripts
-- =====================================================================

-- Reusable bind actions (in-process Lua, no subprocess/hyprctl/jq).
-- binds.lua does `local act = require("scripts")`.
local M = {}

-- Forward a scrolling-layout `layoutmsg`, but only on the scrolling layout:
-- colresize/consume/expel are unknown on master/dwindle and pop an error
-- notification, so guard on tiled_layout and no-op elsewhere.
function M.scroller_msg(msg)
    local ws = hl.get_active_workspace()
    if ws and ws.tiled_layout == "scrolling" then
        hl.dispatch(hl.dsp.layout(msg))
    end
end

-- Layout-aware focus along the wheel.
--   scrolling layout -> step PREV/NEXT along the tape over EVERY tiled window
--     (incl. consumed/stacked), CLAMPing at the ends instead of wrapping or
--     jumping monitor. Tape order follows the monitor's effective orientation
--     (transforms 1/3/5/7 are 90/270-rotated, so swap w/h first):
--       landscape -> x-major (along tape, then down consumed)
--       portrait  -> y-major (down tape, then across consumed)
--   dwindle/master   -> cycle every window on the workspace (wraps).
-- up = next along the tape, down = prev.
function M.wheel_focus(dir)
    local ws = hl.get_active_workspace()
    if not ws then return end

    if ws.tiled_layout ~= "scrolling" then
        hl.dispatch(hl.dsp.window.cycle_next({ [dir == "up" and "prev" or "next"] = true }))
        return
    end

    local mon = ws.monitor
    local ew, eh = mon.width, mon.height
    if mon.transform % 2 == 1 then ew, eh = eh, ew end
    local portrait = eh > ew

    local tiled = {}
    for _, w in ipairs(hl.get_workspace_windows(ws.id)) do
        if not w.floating and w.mapped then tiled[#tiled + 1] = w end
    end
    table.sort(tiled, function(a, b)
        local a1, a2, b1, b2 = a.at.x, a.at.y, b.at.x, b.at.y
        if portrait then a1, a2, b1, b2 = a2, a1, b2, b1 end -- y-major
        if a1 ~= b1 then return a1 < b1 end
        if a2 ~= b2 then return a2 < b2 end
        return a.address < b.address -- stable tiebreak
    end)

    local cur = hl.get_active_window()
    local curaddr = cur and cur.address
    local idx
    for i, w in ipairs(tiled) do
        if w.address == curaddr then
            idx = i; break
        end
    end
    if not idx then return end -- focused window off the tape (e.g. floating)

    local target = dir == "up" and idx + 1 or idx - 1
    if target < 1 or target > #tiled then return end -- at an end -> stop
    hl.dispatch(hl.dsp.focus({ window = "address:" .. tiled[target].address }))
end

-- Cross-axis resizeactive on the scrolling layout: Hyprland picks a different
-- border to move depending on whether the window has a "prev" neighbour in
-- its band (see scrolling-resize-first-window-bug), which flips the sign of
-- delta.x on a portrait band / delta.y on a landscape band for every window
-- but the first. Detect that case from geometry and negate the cross-axis
-- component so scroll direction always means the same thing regardless of
-- position in the row. dwindle/master and the tape-axis component pass
-- through unchanged.
function M.wheel_resize(delta)
    local ws = hl.get_active_workspace()
    local cur = ws and hl.get_active_window()
    if not ws or not cur or ws.tiled_layout ~= "scrolling" then
        hl.dispatch(hl.dsp.window.resize({ x = delta.x, y = delta.y, relative = true }))
        return
    end

    local mon = ws.monitor
    local ew, eh = mon.width, mon.height
    if mon.transform % 2 == 1 then ew, eh = eh, ew end
    local portrait = eh > ew

    local function cross(w) return portrait and w.at.x or w.at.y end
    local function tape(w) return portrait and w.at.y or w.at.x end

    local t, c = tape(cur), cross(cur)
    local has_prev = false
    for _, w in ipairs(hl.get_workspace_windows(ws.id)) do
        if not w.floating and w.mapped and w.address ~= cur.address
            and math.abs(tape(w) - t) < 10 and cross(w) < c then
            has_prev = true
            break
        end
    end

    local dx, dy = delta.x, delta.y
    if has_prev then
        if portrait then dx = -dx else dy = -dy end
    end
    hl.dispatch(hl.dsp.window.resize({ x = dx, y = dy, relative = true }))
end

-- Register the 1-10 workspace switch/move binds plus next/prev cycling. Uses the
-- split-monitor-workspaces plugin for per-monitor workspaces when it's loaded,
-- else falls back to native GLOBAL workspaces (e.g. a stale .so after a Hyprland
-- upgrade — run `hyprpm update`) so the keys keep working. SUPER+0 -> ws 10.
function M.bind_workspaces()
    for i = 1, 10 do
        local idx = i
        local n = tostring(idx)
        local key = (i == 10) and "0" or n
        hl.bind("SUPER + " .. key, function()
            local smw = hl.plugin and hl.plugin.split_monitor_workspaces
            if smw then
                smw.workspace(n)
            else
                hl.dispatch(hl.dsp.focus({ workspace = idx }))
            end
        end)
        hl.bind("SUPER + SHIFT + " .. key, function()
            local smw = hl.plugin and hl.plugin.split_monitor_workspaces
            if smw then
                smw.move_to_workspace(n)
            else
                hl.dispatch(hl.dsp.window.move({ workspace = idx }))
            end
        end)
    end
    local function cycle_workspace(dir)
        local smw = hl.plugin and hl.plugin.split_monitor_workspaces
        if smw then
            smw.cycle_workspaces(dir)
        else
            hl.dispatch(hl.dsp.focus({ workspace = dir == "next" and "e+1" or "e-1" }))
        end
    end
    hl.bind("SUPER + U", function() cycle_workspace("next") end)
    hl.bind("SUPER + I", function() cycle_workspace("prev") end)
    hl.bind("SUPER + Page_Down", function() cycle_workspace("next") end)
    hl.bind("SUPER + Page_Up", function() cycle_workspace("prev") end)
end

-- Toggle the active workspace between dwindle and the native scrolling layout, in
-- place. `hyprctl keyword` won't re-tile a live workspace, so set a rule for just
-- this workspace and re-apply via hl.config so only it re-tiles. Scroll direction
-- + fresh-column width follow the monitor orientation (portrait = down/33%,
-- landscape = right/50%). column_width is global-only, so bump it for the re-tile
-- then restore the 0.333 baseline a tick later (existing columns keep their width).
function M.toggle_layout()
    local ws = hl.get_active_workspace()
    if not ws then return end
    local id = tostring(ws.id)
    if ws.tiled_layout == "scrolling" then
        hl.workspace_rule({ workspace = id, layout = "dwindle" })
        hl.config({ general = { layout = "dwindle" } })
    else
        local mon = ws.monitor
        local ew, eh = mon.width, mon.height
        if mon.transform % 2 == 1 then ew, eh = eh, ew end
        local dir, cw = "right", 0.5
        if eh > ew then dir, cw = "down", 0.333 end
        hl.config({ scrolling = { column_width = cw } })
        hl.workspace_rule({ workspace = id, layout = "scrolling", layout_opts = { direction = dir } })
        hl.config({ general = { layout = "dwindle" } })
        hl.timer(function() hl.config({ scrolling = { column_width = 0.333 } }) end,
            { timeout = 100, type = "oneshot" })
    end
end

-- Walk the focused window through the scrolling layout in reading order, using
-- only movewindow. Within its band it slides along the cross axis (l/r on a
-- vertical/"down" scroller, u/d on a horizontal one). At the band edge a
-- window that still shares its band expels into a full-width band of its own
-- just past the edge; one already alone crosses into the adjacent band, then
-- walks to that band's reading-order end: the FRONT (leftmost) when going
-- forward so the window lands at the start of the next row, the BACK
-- (rightmost) of the band above when going back. The layout drops the crossed
-- window at an unpredictable slot (it depends on the window's cross position),
-- so we step one swap at a time and re-read after each move --
-- get_workspace_windows reflects the move immediately -- until nothing in the
-- band lies beyond us. A lone window at the first/last band clamps (no wrap,
-- no monitor jump).
-- dir: "back" (left/up) | "forward" (right/down).
function M.move_flow(dir)
    local ws = hl.get_active_workspace()
    if not ws or ws.tiled_layout ~= "scrolling" then return end
    local cur = hl.get_active_window()
    if not cur then return end

    local mon = ws.monitor
    local ew, eh = mon.width, mon.height
    if mon.transform % 2 == 1 then ew, eh = eh, ew end
    local portrait = eh > ew
    -- primary slides within the band; secondary crosses to the adjacent band;
    -- anti_primary walks a crossed window toward the front of its new band.
    local primary, secondary, anti_primary
    if dir == "back" then
        primary, secondary, anti_primary = portrait and "l" or "u", portrait and "u" or "l", portrait and "r" or "d"
    else
        primary, secondary, anti_primary = portrait and "r" or "d", portrait and "d" or "r", portrait and "l" or "u"
    end
    local function cross(w) return portrait and w.at.x or w.at.y end
    local function tape(w) return portrait and w.at.y or w.at.x end

    -- gather tiled windows; seg = the focused window's band (shares its tape pos)
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

    -- slide within the band until we reach its leading/trailing edge
    local at_edge
    if dir == "back" then at_edge = idx == 1 else at_edge = idx == #seg end
    if not at_edge then
        hl.dispatch(hl.dsp.window.move({ direction = primary }))
        return
    end

    -- at the edge of a shared band: expel into a full-width band of its own just
    -- past this edge instead of merging straight into the neighbouring band; the
    -- next press, now alone, crosses into it.
    if #seg > 1 then
        hl.dispatch(hl.dsp.layout(dir == "back" and "consume_or_expel prev" or "consume_or_expel next"))
        return
    end

    -- alone in its band: cross into the band just beyond this edge (nearest tape
    -- value past the current); a lone window at the tape end has nowhere to go.
    local next_tape
    for _, w in ipairs(tiled) do
        local wt = tape(w)
        if dir == "back" then
            if wt < t - 10 and (not next_tape or wt > next_tape) then next_tape = wt end
        else
            if wt > t + 10 and (not next_tape or wt < next_tape) then next_tape = wt end
        end
    end
    if not next_tape then return end -- clamp: no wrap, no monitor jump

    hl.dispatch(hl.dsp.window.move({ direction = secondary }))
    -- step toward the band's reading-order end until nothing lies beyond us
    -- (forward -> smaller cross/front; back -> larger cross/end). anti_primary
    -- points that way. Re-read each pass so we stop exactly at the edge instead
    -- of overshooting into the neighbouring band.
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
