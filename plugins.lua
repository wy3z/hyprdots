local EXTRA_BORDERS = 2

hl.config({
    plugin = {
        borders_plus_plus = {
            add_borders = EXTRA_BORDERS,
            natural_rounding = false,
            col = {
                border_1 = "rgb(5c5c5c)",
                border_2 = "rgb(000000)",
            },
            border_size_1 = 1,
            border_size_2 = 1,
        },
    },
})

-- Hide extra borders in overview to avoid misaligned decorations while dragging.
local function sync_overview_borders(submap)
    hl.config({
        plugin = {
            borders_plus_plus = {
                add_borders = submap == "scrolloverview" and 0 or EXTRA_BORDERS,
            },
        },
    })
end

local smw = hl.plugin and hl.plugin.split_monitor_workspaces
if smw then
    hl.config({
        plugin = {
            split_monitor_workspaces = {
                enable_persistent_workspaces = false,
            },
        },
    })

    smw.monitor_priority({ "DP-2", "HDMI-A-1" })
end

local scrolloverview = hl.plugin and hl.plugin.scrolloverview
if scrolloverview then
    scrolloverview.configure({
        gesture_distance = 300,
        scale = 0.4,
        workspace_gap = 60,
        layout = "auto",
        cross_monitor_drag = true,
        wallpaper = 2, -- 0: global only, 1: per-workspace only, 2: both
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

hl.on("keybinds.submap", sync_overview_borders)
sync_overview_borders(hl.get_current_submap())
