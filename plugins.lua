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

    local hymission = hl.plugin and hl.plugin.hymission
    if hymission then
        hl.config({
            plugin = {
                hymission = {
                    layout_engine = 'natural',
                    one_workspace_per_row = 1,
                    overview_focus_follows_mouse = 1,
                    multi_workspace_sort_recent_first = 1,
                    toggle_switch_mode = 1,
                    switch_toggle_auto_next = 0,
                    bar_single_mission_control = 0,
                    show_focus_indicator = 0,
                    close_button_enabled = 0,
                    only_active_monitor = 1,
                },
            },
        })
    end
end

M.apply()

return M
