local M = {}


function M.focus(idx)
    local n = tostring(idx)
    local smw = hl.plugin and hl.plugin.split_monitor_workspaces
    if smw then
        smw.workspace(n)
    else
        hl.dispatch(hl.dsp.focus({ workspace = idx }))
    end
end


function M.move(idx)
    local n = tostring(idx)
    local smw = hl.plugin and hl.plugin.split_monitor_workspaces
    if smw then
        smw.move_to_workspace(n)
    else
        hl.dispatch(hl.dsp.window.move({ workspace = idx }))
    end
end

function M.cycle(dir)
    local active = hl.get_active_workspace()
    local monitor = hl.get_active_monitor()
    if not active or not monitor then return end

    local occupied = {}
    for _, ws in ipairs(hl.get_workspaces()) do
        if ws.id > 0 and ws.windows > 0 and ws.monitor and ws.monitor.name == monitor.name then
            occupied[#occupied + 1] = ws
        end
    end
    if #occupied == 0 then return end

    table.sort(occupied, function(a, b) return a.id < b.id end)

    local target
    if dir == "next" then
        for _, ws in ipairs(occupied) do
            if ws.id > active.id then target = ws; break end
        end
    else
        for i = #occupied, 1, -1 do
            if occupied[i].id < active.id then target = occupied[i]; break end
        end
    end
    if not target or target.id == active.id then return end

    local smw = hl.plugin and hl.plugin.split_monitor_workspaces
    if smw then
        local monitor_workspace = ((target.id - 1) % 10) + 1
        smw.workspace(tostring(monitor_workspace))
    else
        hl.dispatch(hl.dsp.focus({ workspace = target.id }))
    end
end


function M.move_to_empty()
    local window = hl.get_active_window()
    local active = hl.get_active_workspace()
    if not window or not active or active.id < 1 then return end

    local first = math.floor((active.id - 1) / 10) * 10 + 1
    local occupied = {}
    for _, candidate in ipairs(hl.get_windows()) do
        if candidate.mapped and candidate.workspace then
            occupied[candidate.workspace.id] = true
        end
    end

    for target = first, first + 9 do
        if not occupied[target] then
            hl.dispatch(hl.dsp.window.move({
                workspace = target,
                window = window,
                follow = true,
            }))
            return
        end
    end
end

return M
