local M = {}
local BAR = "Island"
local SHOW_SETTLE_SECONDS = 0.35
local overview_monitor
local shown = {}
local pin_timers = {}
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

local function cancel_pin(monitor)
    local timer = pin_timers[monitor]
    if timer then
        timer:set_enabled(false)
        pin_timers[monitor] = nil
    end
end

local function show_for_overview(monitor)
    -- Turning auto-hide off reveals the bar immediately. Ask Noctalia to show it
    -- first so its normal slide animation runs, then pin it once that animation
    -- has had time to finish. Keeping the delay in Lua lets us cancel it if the
    -- overview closes before the animation completes.
    cancel_pin(monitor)
    hl.exec_cmd(string.format("noctalia msg bar-show %s %s", BAR, monitor))
    pin_timers[monitor] = hl.timer(function()
        pin_timers[monitor] = nil
        if overview_monitor == monitor then set_auto_hide(monitor, false) end
    end, { timeout = SHOW_SETTLE_SECONDS * 1000, type = "oneshot" })
end

local function refresh()
    local present = {}
    for _, monitor in ipairs(hl.get_monitors()) do
        present[monitor.name] = true
        local should_show = monitor.name == overview_monitor

        if shown[monitor.name] ~= should_show then
            shown[monitor.name] = should_show
            if should_show then
                show_for_overview(monitor.name)
            else
                cancel_pin(monitor.name)
                set_auto_hide(monitor.name, true)
            end
        end
    end

    for monitor in pairs(shown) do
        if not present[monitor] then
            shown[monitor] = nil
            cancel_pin(monitor)
        end
    end
end

local function schedule_refresh()
    if not ready then return end
    if refresh_timer then refresh_timer:set_enabled(false) end
    refresh_timer = hl.timer(refresh, { timeout = 1, type = "oneshot" })
end

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
