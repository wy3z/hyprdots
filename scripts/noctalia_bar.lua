    local M = {}
local BAR = "Island"
local overview_monitor
local shown = {}
local refresh_timer
local ready = false

local function set_auto_hide(monitor, enabled)
    hl.exec_cmd(string.format(
        "noctalia msg bar-auto-hide-set %s %s %s",
        enabled and "on" or "off",
        BAR,
        monitor
    ))
end

local function refresh()
    local present = {}
    for _, monitor in ipairs(hl.get_monitors()) do
        present[monitor.name] = true
        local should_show = monitor.name == overview_monitor

        if shown[monitor.name] ~= should_show then
            shown[monitor.name] = should_show
            set_auto_hide(monitor.name, not should_show)
        end
    end

    for monitor in pairs(shown) do
        if not present[monitor] then shown[monitor] = nil end
    end
end

local function schedule_refresh()
    if not ready then return end
    if refresh_timer then refresh_timer:set_enabled(false) end
    refresh_timer = hl.timer(refresh, { timeout = 1, type = "oneshot" })
end

-- Reserve space is driven from Noctalia's own settings; use a bar show/hide bind.
-- function M.toggle()
--     local monitor = hl.get_active_monitor()
--     if not monitor then return end
--
--     local reserved = monitor.reserved
--     local has_reserved_space = reserved.top > 0 or reserved.right > 0
--         or reserved.bottom > 0 or reserved.left > 0
--
--     if has_reserved_space then
--         hl.exec_cmd("noctalia msg bar-reserve-toggle " .. BAR)
--     else
--         hl.exec_cmd("noctalia msg bar-reserve-toggle " .. BAR .. " && noctalia msg bar-show " .. BAR)
--     end
-- end

hl.on("keybinds.submap", function(name)
    if name == "scrolloverview" then
        local monitor = hl.get_active_monitor()
        overview_monitor = monitor and monitor.name or nil
    else
        overview_monitor = nil
    end
    schedule_refresh()
end)

for _, event in ipairs({ "monitor.added", "monitor.removed" }) do
    hl.on(event, schedule_refresh)
end

hl.on("hyprland.start", function()
    -- Noctalia starts concurrently, so allow its IPC service to become ready.
    hl.timer(refresh, { timeout = 1000, type = "oneshot" })
end)

hl.timer(function() ready = true end, { timeout = 500, type = "oneshot" })

return M
