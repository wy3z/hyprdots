local policy = require("scripts.monitor_policy")
local scrolling = require("scripts.scrolling")
local workspaces = require("scripts.workspaces")
local voxtype = require("scripts.voxtype")
local screen_toolkit = require("scripts.screen_toolkit")
local windows = require("scripts.windows")

hl.bind("SUPER + CTRL + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"),
    { description = "Reload Hyprland config" })
hl.bind("SUPER + CTRL + SHIFT + E", hl.dsp.exit(), { description = "Exit Hyprland" })

hl.bind("SUPER + Return", hl.dsp.exec_cmd("ghostty +new-window"), { description = "Open terminal" })
hl.bind("SUPER + E", hl.dsp.exec_cmd("nautilus --new-window"), { description = "Open file manager in a new window" })
hl.bind("SUPER + B", hl.dsp.exec_cmd("helium-browser"), { description = "Open browser" })
hl.bind("SUPER + N", hl.dsp.exec_cmd("iotas"), { description = "Open notes" })

hl.bind("SUPER + Space", hl.dsp.exec_cmd("vicinae toggle"), { description = "Open launcher" })
hl.bind("SUPER + K", hl.dsp.exec_cmd("noctalia msg panel-toggle kenn/keybind-cheatsheet:cheatsheet"),
    { description = "Show keybindings" })
hl.bind("SUPER + V", hl.dsp.exec_cmd("noctalia msg panel-toggle clipboard"),
    { description = "Show clipboard history" })
hl.bind("SUPER + comma", hl.dsp.exec_cmd("noctalia msg settings-toggle"),
    { description = "Open shell settings" })

hl.bind("SUPER + SHIFT + J", hl.dsp.exec_cmd("noctalia msg panel-toggle control-center notifications"),
    { description = "Open notifications panel" })
hl.bind("SUPER + M", hl.dsp.exec_cmd("noctalia msg panel-toggle control-center system"),
    { description = "Open system panel" })
hl.bind("SUPER + Y", hl.dsp.exec_cmd("noctalia msg panel-toggle wallpaper"),
    { description = "Open wallpaper picker" })
hl.bind("SUPER + CTRL + B", hl.dsp.exec_cmd("noctalia msg bar-toggle"), { description = "Toggle bar visibility" })
hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd("noctalia msg panel-toggle control-center system"),
    { description = "Open system panel" })

hl.bind("SUPER + CTRL + L", hl.dsp.exec_cmd("noctalia msg session lock"),
    { description = "Lock screen" })

hl.bind("SUPER + Escape", hl.dsp.exec_cmd("noctalia msg panel-toggle session"),
    { description = "Open session menu" })
hl.bind("SUPER + SHIFT + Escape", hl.dsp.exec_cmd("noctalia msg panel-toggle tordex/processes:panel"),
    { description = "Open processes panel" })
hl.bind("ALT + Tab", hl.dsp.exec_cmd("noctalia msg window-switcher"), { description = "Open window switcher" })

hl.bind("SUPER + CTRL + comma", hl.dsp.exec_cmd("noctalia msg notification-clear-active"),
    { description = "Dismiss active notifications" })
hl.bind("SUPER + ALT + comma", hl.dsp.exec_cmd("noctalia msg notification-invoke-latest"),
    { description = "Invoke latest notification action" })
hl.bind("SUPER + SHIFT + comma", hl.dsp.exec_cmd("noctalia msg notification-dnd-toggle"),
    { description = "Toggle do not disturb" })

hl.bind("SUPER + CTRL + I", hl.dsp.exec_cmd("noctalia msg caffeine-toggle"),
    { description = "Toggle idle inhibitor (caffeine)" })
hl.bind("SUPER + CTRL + N", hl.dsp.exec_cmd("noctalia msg nightlight-force-toggle"),
    { description = "Toggle night light" })

hl.bind("ALT + Space", voxtype.press, { description = "Start dictation (tap or hold)" })
hl.bind("ALT + Space", voxtype.release, { release = true, description = "Stop dictation (on release)" })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("noctalia msg volume-up"),
    { locked = true, repeating = true, description = "Raise volume" })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("noctalia msg volume-down"),
    { locked = true, repeating = true, description = "Lower volume" })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("noctalia msg volume-mute"),
    { locked = true, description = "Mute speakers" })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("noctalia msg mic-mute"),
    { locked = true, description = "Mute microphone" })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("noctalia msg media toggle"),
    { locked = true, description = "Play or pause media" })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("noctalia msg media toggle"),
    { locked = true, description = "Play or pause media" })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("noctalia msg media next"),
    { locked = true, description = "Skip to next track" })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("noctalia msg media previous"),
    { locked = true, description = "Skip to previous track" })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("noctalia msg brightness-up"),
    { locked = true, repeating = true, description = "Raise screen brightness" })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("noctalia msg brightness-down"),
    { locked = true, repeating = true, description = "Lower screen brightness" })

hl.bind("SUPER + Q", hl.dsp.window.close(), { description = "Close window" })
hl.bind("SUPER + T", windows.pop, { description = "Float window out, centred and pinned" })
hl.bind("SUPER + SHIFT + T", hl.dsp.window.pin(), { description = "Pin window to all workspaces" })
hl.bind("SUPER + C", hl.dsp.window.center(), { description = "Centre window" })
hl.bind("SUPER + O", hl.dsp.window.float({ action = "toggle" }), { description = "Toggle floating, keeping size and position" })
hl.bind("SUPER + ALT + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }),
    { description = "Maximize window (toggle)" })
hl.bind("SUPER + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }),
    { description = "Fullscreen window (toggle)" })
hl.bind("SUPER + J", function()
    local ws = hl.get_active_workspace()
    if ws and ws.tiled_layout == "dwindle" then
        hl.dispatch(hl.dsp.layout("togglesplit"))
    end
end, { description = "Toggle dwindle split orientation" })

local directions = {
    { keys = { "A", "Left" }, name = "left", move = "l", x = -50, y = 0, resize = "narrower (50px)" },
    { keys = { "S", "Down" }, name = "down", move = "d", x = 0, y = 50, resize = "taller (50px)" },
    { keys = { "W", "Up" }, name = "up", move = "u", x = 0, y = -50, resize = "shorter (50px)" },
    { keys = { "D", "Right" }, name = "right", move = "r", x = 50, y = 0, resize = "wider (50px)" },
}

for _, direction in ipairs(directions) do
    for _, key in ipairs(direction.keys) do
        hl.bind("SUPER + " .. key, hl.dsp.focus({ direction = direction.name }),
            { description = "Focus window " .. direction.name })
    end
end

for _, direction in ipairs(directions) do
    for _, key in ipairs(direction.keys) do
        hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ direction = direction.move }),
            { description = "Move window " .. direction.name })
    end
end

for i = 1, policy.workspaces_per_monitor do
    local idx = i
    local key = (i == 10) and "0" or tostring(i)
    hl.bind("SUPER + " .. key, function() workspaces.focus(idx) end,
        { description = "Focus workspace " .. idx })
    hl.bind("SUPER + SHIFT + " .. key, function() workspaces.move(idx) end,
        { description = "Move window to workspace " .. idx })
end
hl.bind("SUPER + U", function() workspaces.cycle("prev") end,
    { description = "Focus previous workspace" })
hl.bind("SUPER + I", function() workspaces.cycle("next") end,
    { description = "Focus next workspace" })
hl.bind("SUPER + Page_Up", function() workspaces.cycle("prev") end,
    { description = "Focus previous workspace" })
hl.bind("SUPER + Page_Down", function() workspaces.cycle("next") end,
    { description = "Focus next workspace" })

hl.bind("SUPER + SHIFT + E", workspaces.move_to_empty,
    { description = "Move window to empty workspace" })

hl.bind("SUPER + CTRL + Left", hl.dsp.focus({ monitor = "l" }),
    { description = "Focus monitor to the left" })
hl.bind("SUPER + CTRL + Right", hl.dsp.focus({ monitor = "r" }),
    { description = "Focus monitor to the right" })
hl.bind("SUPER + SHIFT + CTRL + Left", function()
    scrolling.preserve_width(function() hl.dispatch(hl.dsp.window.move({ monitor = "l" })) end)
end, { description = "Move window to the monitor on the left" })
hl.bind("SUPER + SHIFT + CTRL + Right", function()
    scrolling.preserve_width(function() hl.dispatch(hl.dsp.window.move({ monitor = "r" })) end)
end, { description = "Move window to the monitor on the right" })

hl.bind("SUPER + F", scrolling.col_maximize, { submap_universal = true, description = "Maximize window or column (toggle)" })
hl.bind("SUPER + Z", function()
    scrolling.col_step("down")
end, { submap_universal = true, description = "Shrink column to previous width preset" })
hl.bind("SUPER + X", function()
    scrolling.col_step("up")
end, { submap_universal = true, description = "Grow column to next width preset" })
hl.bind("SUPER + SHIFT + Z", function()
    scrolling.col_set(policy.portrait_width)
end, { submap_universal = true, description = "Set column width to 33%" })
hl.bind("SUPER + SHIFT + X", function()
    scrolling.col_set(1.0)
end, { submap_universal = true, description = "Set column width to 100%" })

hl.bind("SUPER + ALT + mouse_up", hl.dsp.window.resize({ x = 100, y = 0, relative = true }),
    { submap_universal = true, description = "Resize window wider (100px)" })
hl.bind("SUPER + ALT + mouse_down", hl.dsp.window.resize({ x = -100, y = 0, relative = true }),
    { submap_universal = true, description = "Resize window narrower (100px)" })

hl.bind("SUPER + bracketleft", function()
    scrolling.move_flow("back")
end, { description = "Move window back" })
hl.bind("SUPER + bracketright", function()
    scrolling.move_flow("forward")
end, { description = "Move window forward" })

hl.bind("SUPER + SHIFT + mouse_up", function()
    scrolling.move_flow("back")
end, { description = "Move window back" })
hl.bind("SUPER + SHIFT + mouse_down", function()
    scrolling.move_flow("forward")
end, { description = "Move window forward" })

hl.bind("SUPER + L", function()
    scrolling.toggle_layout()
end, { description = "Toggle scrolling / dwindle layout" })

local scrolloverview = hl.plugin and hl.plugin.scrolloverview
if scrolloverview then
    hl.bind("SUPER + TAB", scrolloverview.overview("toggle"),
        { description = "Toggle workspace overview" })
end

for _, direction in ipairs(directions) do
    for _, key in ipairs(direction.keys) do
        hl.bind("SUPER + ALT + " .. key,
            hl.dsp.window.resize({ x = direction.x, y = direction.y, relative = true }),
            { repeating = true, submap_universal = true,
                description = "Resize window " .. direction.resize })
    end
end

local ZOOM_MAX = 10

local function zoom_by(delta)
    return function()
        local zoom = hl.get_config("cursor.zoom_factor") or 1
        hl.config({ cursor = { zoom_factor = math.min(ZOOM_MAX, math.max(1, zoom + delta)) } })
    end
end

hl.bind("SUPER + CTRL + X", zoom_by(0.5), { repeating = true, description = "Zoom screen in" })
hl.bind("SUPER + CTRL + Z", zoom_by(-0.5), { repeating = true, description = "Zoom screen out" })
hl.bind("SUPER + CTRL + ALT + Z", function()
    hl.config({ cursor = { zoom_factor = 1 } })
end, { description = "Reset screen zoom" })

hl.bind("SUPER + CTRL + mouse_up", zoom_by(0.25), { description = "Zoom screen in" })
hl.bind("SUPER + CTRL + mouse_down", zoom_by(-0.25), { description = "Zoom screen out" })

hl.bind("Print", hl.dsp.exec_cmd("noctalia msg screenshot-region"), { description = "Screenshot a region" })
hl.bind("SUPER + Print", screen_toolkit.toggle, { description = "Toggle screen recording" })
hl.bind("ALT + Print", hl.dsp.exec_cmd("noctalia msg screenshot-fullscreen pick"),
    { description = "Screenshot a monitor (pick)" })
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("noctalia msg screenshot-fullscreen"),
    { description = "Screenshot the focused monitor" })

hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Drag window" })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(),
    { mouse = true, submap_universal = true, description = "Resize window by dragging" })
hl.bind("SUPER + mouse:274", windows.pop,
    { mouse = true, description = "Float window out, centred and pinned" })

hl.bind("SUPER + CTRL + mouse:274", scrolling.col_maximize,
    { mouse = true, description = "Maximize window or column (toggle)" })
hl.bind("SUPER + ALT + mouse:274", function()
    scrolling.col_step("up", true)
end, { mouse = true, description = "Cycle column width presets" })

hl.bind("SUPER + mouse:275", function()
    scrolling.move_flow("forward")
end, { mouse = true, description = "Move window forward" })
hl.bind("SUPER + mouse:276", function()
    scrolling.move_flow("back")
end, { mouse = true, description = "Move window back" })

hl.bind("SUPER + mouse_down", function()
    scrolling.wheel_focus("up")
end, { description = "Focus next window" })
hl.bind("SUPER + mouse_up", function()
    scrolling.wheel_focus("down")
end, { description = "Focus previous window" })

local function define_scrolloverview_submap()
    local scrolloverview = hl.plugin and hl.plugin.scrolloverview
    if not scrolloverview then
        return
    end

    hl.define_submap("scrolloverview", function()
        hl.bind("Left", scrolloverview.navigate("left"), { description = "Navigate left" })
        hl.bind("Right", scrolloverview.navigate("right"), { description = "Navigate right" })
        hl.bind("Up", scrolloverview.navigate("up"), { description = "Navigate up" })
        hl.bind("Down", scrolloverview.navigate("down"), { description = "Navigate down" })
        local function navigate_overview_wheel(portrait_direction, landscape_direction)
            return function()
                local monitor = hl.get_active_monitor()
                local direction = monitor and policy.is_portrait(monitor) and portrait_direction or landscape_direction
                scrolloverview.navigate(direction)
            end
        end

        hl.bind("SUPER + mouse_up", navigate_overview_wheel("up", "left"),
            { description = "Navigate back" })
        hl.bind("SUPER + mouse_down", navigate_overview_wheel("down", "right"),
            { description = "Navigate forward" })

        for i = 1, policy.workspaces_per_monitor do
            local idx = i
            local key = (i == 10) and "0" or tostring(i)
            hl.bind("SUPER + " .. key, function()
                workspaces.focus(idx)
            end, { description = "Focus overview workspace " .. idx })
        end

        hl.bind("SUPER + TAB", scrolloverview.overview("off"), { description = "Close overview" })
        hl.bind("Return", scrolloverview.overview("select"), { description = "Select workspace" })
        hl.bind("Escape", scrolloverview.overview("off"), { description = "Close overview" })
        hl.bind("SUPER + mouse:272", hl.dsp.window.drag(),
            { mouse = true, submap_universal = true, description = "Drag window in overview" })
        hl.bind("mouse:272", function()
            scrolloverview.overview("select")
            scrolloverview.window("select")
            scrolloverview.overview("off")
        end, { mouse = true, description = "Select window" })
        hl.bind("mouse:274", scrolloverview.window("close"), { mouse = true, description = "Close window in overview" })
    end)
end

define_scrolloverview_submap()
