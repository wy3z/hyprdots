local M = {
    workspaces_per_monitor = 10,
    monitor_order = { "DP-2", "HDMI-A-1" },
    landscape_width = 0.5,
    portrait_width = 0.333,
}

M.monitor_widths = {
    ["DP-2"] = M.landscape_width,
    ["HDMI-A-1"] = M.portrait_width,
}

function M.size(monitor)
    local width, height = monitor.width, monitor.height
    if monitor.transform % 2 == 1 then width, height = height, width end
    return width, height
end

function M.is_portrait(monitor)
    local width, height = M.size(monitor)
    return height > width
end

function M.column_width(portrait)
    return portrait and M.portrait_width or M.landscape_width
end

function M.workspace_base(id)
    if not id or id < 1 then return nil end
    return math.floor((id - 1) / M.workspaces_per_monitor) * M.workspaces_per_monitor
end

function M.monitor_workspace_base(monitor)
    local workspace = monitor.active_workspace
    local base = M.workspace_base(workspace and workspace.id)
    if base and base < #M.monitor_order * M.workspaces_per_monitor then return base end
end

return M
