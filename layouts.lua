-- Workspaces 1-10 live on one monitor and 11-20 on the other, but which block
-- lands where is decided by split-monitor-workspaces at monitor-add time and
-- cannot be relied on (monitor_priority only applies as monitors appear). So
-- the scroll direction is derived from the monitor that actually owns a block
-- rather than hardcoded per workspace id.
local function block_base(monitor)
    local ws = monitor.active_workspace
    if not ws or not ws.id then return nil end
    if ws.id >= 1 and ws.id <= 10 then return 0 end
    if ws.id >= 11 and ws.id <= 20 then return 10 end
    return nil
end

local function apply_directions()
    for _, monitor in ipairs(hl.get_monitors()) do
        local base = block_base(monitor)
        if base then
            local width, height = monitor.width, monitor.height
            if monitor.transform % 2 == 1 then width, height = height, width end
            local direction = height > width and "down" or "right"
            for i = 1, 10 do
                hl.workspace_rule({
                    workspace = tostring(base + i),
                    layout = "scrolling",
                    layout_opts = { direction = direction },
                })
            end
        end
    end
end

-- Portrait monitor's block displays as 1-10 instead of 11-20.
for ws = 11, 20 do
    hl.workspace_rule({
        workspace = tostring(ws),
        default_name = tostring(ws - 10),
    })
end

apply_directions()
-- Monitors are still being assigned their workspace block while the config runs.
hl.timer(apply_directions, { timeout = 500, type = "oneshot" })
for _, event in ipairs({ "monitorAdded", "monitorRemoved", "monitorLayoutChanged" }) do
    pcall(hl.on, event, apply_directions)
end

hl.config({
    scrolling = {
        -- Fallback for columns created after window rules run.
        column_width = 0.333,
        wrap_focus = false,
        fullscreen_on_one_column = false,
    },
})
