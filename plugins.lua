local M = {}

function M.apply()
    local smw = hl.plugin and hl.plugin.split_monitor_workspaces
    if smw then
        -- Workspaces 1-10 on DP-5; 11-20 on HDMI-A-2.
        smw.monitor_priority({ "DP-5", "HDMI-A-2" })
    end

    local scrolloverview = hl.plugin and hl.plugin.scrolloverview
    if scrolloverview then
        scrolloverview.configure({
            workspace_gap = 100,
            hide_empty_workspaces = true,
            input = {
                scrolling_mode = 2,
                scroll_event_delay = 30,
            },
        })
    end
end

M.apply()

return M
