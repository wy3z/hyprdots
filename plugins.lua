local policy = require("scripts.monitor_policy")

local smw = hl.plugin and hl.plugin.split_monitor_workspaces
if smw then
    hl.config({
        plugin = {
            split_monitor_workspaces = {
                enable_persistent_workspaces = false,
                keep_focused = true,
            },
        },
    })

    smw.monitor_priority(policy.monitor_order)
end

local scrolloverview = hl.plugin and hl.plugin.scrolloverview
if scrolloverview then
    scrolloverview.configure({
        gesture_distance = 300,
        scale = 0.5,
        workspace_gap = 30,
        layout = "auto",
        cross_monitor_drag = true,
        wallpaper = 2,
        blur = false,

        shadow = {
            enabled = true,
            range = 32,
            render_power = 2,
            color = 0x60000000,
        },
        input = {
            scrolling_mode = 2,
            scroll_event_delay = 30,
        },
    })
end
