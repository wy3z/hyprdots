local function apply()
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
            layout = "horizontal",
            wallpaper = 2, -- 0: global only, 1: per-workspace only, 2: both
            blur = true,

            shadow = {
                enabled = true,
                range = 32,
                render_power = 2,
                color = 0x40000000,
            },
            input = {
                scrolling_mode = 2,
                scroll_event_delay = 30,
            },
        })
    end
end

apply()
