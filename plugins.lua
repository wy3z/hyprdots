local M = {}

function M.apply()
    local smw = hl.plugin and hl.plugin.split_monitor_workspaces
    if smw then
        -- Note: the config key uses underscores, unlike the hyprlang name.
        hl.config({
            plugin = {
                split_monitor_workspaces = {
                    enable_persistent_workspaces = false,
                },
            },
        })

        -- Preferred order for workspaces 1-10 vs 11-20. Only takes effect for
        -- monitors added after this runs, so the block a monitor ends up with
        -- is not guaranteed; layouts.lua derives scroll direction from the
        -- monitor that actually owns each block instead of assuming.
        smw.monitor_priority({ "DP-5", "HDMI-A-2" })
    end

    local scrolloverview = hl.plugin and hl.plugin.scrolloverview
    if scrolloverview then
        scrolloverview.configure({
            gesture_distance = 300, -- how far is the "max" for the gesture
            scale = 0.5, -- preferred overview scale
            workspace_gap = 100,
            -- Plugin exposes only one global layout key (no per-monitor variant),
            -- so this applies to the portrait monitor's overview too.
            layout = "horizontal",
            wallpaper = 2, -- 0: global only, 1: per-workspace only, 2: both
            blur = true, -- blur only the main overview wallpaper

            shadow = {
                enabled = true,
                range = 50,
                render_power = 3,
                color = 0xee1a1a1a,
            },
            input = {
                scrolling_mode = 2,
                scroll_event_delay = 30,
            },
        })
    end
end

M.apply()

return M
