-- =====================================================================
-- Plugins
-- =====================================================================
local M = {}

function M.apply()
    local smw = hl.plugin and hl.plugin.split_monitor_workspaces
    if smw then
        -- workspace block 1-10 -> landscape DP-5, 11-20 -> portrait HDMI-A-2
        smw.monitor_priority({ "DP-5", "HDMI-A-2" })
    end

    local scrolloverview = hl.plugin and hl.plugin.scrolloverview
    if scrolloverview then
        scrolloverview.configure({
            workspace_gap = 100,
            input = {
                scrolling_mode = 2,
                scroll_event_delay = 30,
            },
        })
    end
end

M.apply()

return M
