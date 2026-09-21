local scrolling = require("scripts.scrolling")
local workspaces = require("scripts.workspaces")
local voxtype = require("scripts.voxtype")
local screen_toolkit = require("scripts.screen_toolkit")
local windows = require("scripts.windows")

-- descriptions feed SUPER+K (kenn/keybind-cheatsheet); undisclosed binds show as "__lua N"
hl.bind("SUPER + CTRL + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"),
    { description = "System: Reload Hyprland config" })
hl.bind("SUPER + CTRL + SHIFT + E", hl.dsp.exit(), { description = "System: Exit Hyprland" })

hl.bind("SUPER + Return", hl.dsp.exec_cmd("ghostty +new-window"), { description = "Apps: Open terminal" })
hl.bind("SUPER + E", hl.dsp.exec_cmd("nautilus"), { description = "Apps: Open file manager" })
hl.bind("SUPER + B", hl.dsp.exec_cmd("helium-browser"), { description = "Apps: Open browser" })
hl.bind("SUPER + N", hl.dsp.exec_cmd("iotas"), { description = "Apps: Open notes" })

hl.bind("SUPER + Space", hl.dsp.exec_cmd("vicinae toggle"), { description = "Shell: Open launcher" })
hl.bind("SUPER + K", hl.dsp.exec_cmd("noctalia msg panel-toggle kenn/keybind-cheatsheet:cheatsheet"),
    { description = "Shell: Show keybindings" })
hl.bind("SUPER + V", hl.dsp.exec_cmd("noctalia msg panel-toggle clipboard"),
    { description = "Shell: Show clipboard history" })
hl.bind("SUPER + comma", hl.dsp.exec_cmd("noctalia msg settings-toggle"),
    { description = "Shell: Open shell settings" })

hl.bind("SUPER + J", hl.dsp.exec_cmd("noctalia msg panel-toggle control-center notifications"),
    { description = "Shell: Open notifications panel" })
hl.bind("SUPER + M", hl.dsp.exec_cmd("noctalia msg panel-toggle control-center system"),
    { description = "Shell: Open system panel" })
hl.bind("SUPER + Y", hl.dsp.exec_cmd("noctalia msg panel-toggle wallpaper"),
    { description = "Shell: Open wallpaper picker" })
hl.bind("SUPER + CTRL + B", hl.dsp.exec_cmd("noctalia msg bar-toggle"), { description = "Shell: Toggle bar visibility" })
hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd("noctalia msg panel-toggle control-center system"),
    { description = "Shell: Open system panel" })
hl.bind("SUPER + CTRL + L", hl.dsp.exec_cmd("noctalia msg session lock"),
    { description = "System: Lock screen" })
hl.bind("SUPER + Escape", hl.dsp.exec_cmd("noctalia msg panel-toggle session"),
    { description = "Shell: Open session menu" })
hl.bind("SUPER + SHIFT + Escape", hl.dsp.exec_cmd("noctalia msg panel-toggle tordex/processes:panel"),
    { description = "Shell: Open processes panel" })
hl.bind("ALT + Tab", hl.dsp.exec_cmd("noctalia msg window-switcher"), { description = "Shell: Open window switcher" })

hl.bind("SUPER + CTRL + comma", hl.dsp.exec_cmd("noctalia msg notification-clear-active"),
    { description = "Notifications: Dismiss active notifications" })
hl.bind("SUPER + ALT + comma", hl.dsp.exec_cmd("noctalia msg notification-invoke-latest"),
    { description = "Notifications: Invoke latest notification action" })
hl.bind("SUPER + SHIFT + comma", hl.dsp.exec_cmd("noctalia msg notification-dnd-toggle"),
    { description = "Notifications: Toggle do not disturb" })

hl.bind("SUPER + CTRL + I", hl.dsp.exec_cmd("noctalia msg caffeine-toggle"),
    { description = "System: Toggle idle inhibitor (caffeine)" })
hl.bind("SUPER + CTRL + N", hl.dsp.exec_cmd("noctalia msg nightlight-force-toggle"),
    { description = "System: Toggle night light" })

hl.bind("ALT + Space", voxtype.press, { description = "Dictation: Start dictation (tap or hold)" })
hl.bind("ALT + Space", voxtype.release, { release = true, description = "Dictation: Stop dictation (on release)" })


hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("noctalia msg volume-up"),
    { locked = true, repeating = true, description = "Media: Raise volume" })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("noctalia msg volume-down"),
    { locked = true, repeating = true, description = "Media: Lower volume" })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("noctalia msg volume-mute"),
    { locked = true, description = "Media: Mute speakers" })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("noctalia msg mic-mute"),
    { locked = true, description = "Media: Mute microphone" })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("noctalia msg media toggle"),
    { locked = true, description = "Media: Play or pause media" })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("noctalia msg media toggle"),
    { locked = true, description = "Media: Play or pause media" })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("noctalia msg media next"),
    { locked = true, description = "Media: Skip to next track" })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("noctalia msg media previous"),
    { locked = true, description = "Media: Skip to previous track" })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("noctalia msg brightness-up"),
    { locked = true, repeating = true, description = "Media: Raise screen brightness" })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("noctalia msg brightness-down"),
    { locked = true, repeating = true, description = "Media: Lower screen brightness" })

hl.bind("SUPER + Q", hl.dsp.window.close(), { description = "Window: Close window" })
hl.bind("SUPER + T", windows.pop, { description = "Window: Float window out, centred and pinned" })
hl.bind("SUPER + SHIFT + T", hl.dsp.window.pin(), { description = "Window: Pin window to all workspaces" })
hl.bind("SUPER + C", hl.dsp.window.center(), { description = "Window: Centre window" })
hl.bind("SUPER + O", hl.dsp.window.float({ action = "toggle" }), { description = "Window: Toggle floating, keeping size and position" })
hl.bind("SUPER + ALT + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }),
    { description = "Window: Maximize window (toggle)" })
hl.bind("SUPER + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }),
    { description = "Window: Fullscreen window (toggle)" })

hl.bind("SUPER + A", hl.dsp.focus({ direction = "left" }), { description = "Focus: Focus window left" })
hl.bind("SUPER + S", hl.dsp.focus({ direction = "down" }), { description = "Focus: Focus window down" })
hl.bind("SUPER + W", hl.dsp.focus({ direction = "up" }), { description = "Focus: Focus window up" })
hl.bind("SUPER + D", hl.dsp.focus({ direction = "right" }), { description = "Focus: Focus window right" })
hl.bind("SUPER + Left", hl.dsp.focus({ direction = "left" }), { description = "Focus: Focus window left" })
hl.bind("SUPER + Down", hl.dsp.focus({ direction = "down" }), { description = "Focus: Focus window down" })
hl.bind("SUPER + Up", hl.dsp.focus({ direction = "up" }), { description = "Focus: Focus window up" })
hl.bind("SUPER + Right", hl.dsp.focus({ direction = "right" }), { description = "Focus: Focus window right" })

hl.bind("SUPER + SHIFT + A", hl.dsp.window.move({ direction = "l" }), { description = "Move: Move window left" })
hl.bind("SUPER + SHIFT + S", hl.dsp.window.move({ direction = "d" }), { description = "Move: Move window down" })
hl.bind("SUPER + SHIFT + W", hl.dsp.window.move({ direction = "u" }), { description = "Move: Move window up" })
hl.bind("SUPER + SHIFT + D", hl.dsp.window.move({ direction = "r" }), { description = "Move: Move window right" })
hl.bind("SUPER + SHIFT + Left", hl.dsp.window.move({ direction = "l" }), { description = "Move: Move window left" })
hl.bind("SUPER + SHIFT + Down", hl.dsp.window.move({ direction = "d" }), { description = "Move: Move window down" })
hl.bind("SUPER + SHIFT + Up", hl.dsp.window.move({ direction = "u" }), { description = "Move: Move window up" })
hl.bind("SUPER + SHIFT + Right", hl.dsp.window.move({ direction = "r" }), { description = "Move: Move window right" })

for i = 1, 10 do
    local idx = i
    local key = (i == 10) and "0" or tostring(i)
    hl.bind("SUPER + " .. key, function() workspaces.focus(idx) end,
        { description = "Workspace: Focus workspace " .. idx })
    hl.bind("SUPER + SHIFT + " .. key, function() workspaces.move(idx) end,
        { description = "Workspace: Move window to workspace " .. idx })
end
hl.bind("SUPER + U", function() workspaces.cycle("prev") end,
    { description = "Workspace: Focus previous workspace" })
hl.bind("SUPER + I", function() workspaces.cycle("next") end,
    { description = "Workspace: Focus next workspace" })
hl.bind("SUPER + Page_Up", function() workspaces.cycle("prev") end,
    { description = "Workspace: Focus previous workspace" })
hl.bind("SUPER + Page_Down", function() workspaces.cycle("next") end,
    { description = "Workspace: Focus next workspace" })

hl.bind("SUPER + SHIFT + E", workspaces.move_to_empty,
    { description = "Workspace: Move window to empty workspace" })

hl.bind("SUPER + CTRL + Left", hl.dsp.focus({ monitor = "l" }),
    { description = "Monitor: Focus monitor to the left" })
hl.bind("SUPER + CTRL + Right", hl.dsp.focus({ monitor = "r" }),
    { description = "Monitor: Focus monitor to the right" })
hl.bind("SUPER + SHIFT + CTRL + Left", function()
    scrolling.preserve_width(function() hl.dispatch(hl.dsp.window.move({ monitor = "l" })) end)
end, { description = "Monitor: Move window to the monitor on the left" })
hl.bind("SUPER + SHIFT + CTRL + Right", function()
    scrolling.preserve_width(function() hl.dispatch(hl.dsp.window.move({ monitor = "r" })) end)
end, { description = "Monitor: Move window to the monitor on the right" })

hl.bind("SUPER + F", scrolling.col_maximize, { submap_universal = true, description = "Column: Maximize column width (toggle)" })
hl.bind("SUPER + Z", function()
    scrolling.col_step("down")
end, { submap_universal = true, description = "Column: Shrink column to previous width preset" })
hl.bind("SUPER + X", function()
    scrolling.col_step("up")
end, { submap_universal = true, description = "Column: Grow column to next width preset" })
hl.bind("SUPER + SHIFT + Z", function()
    scrolling.col_set(0.333)
end, { submap_universal = true, description = "Column: Set column width to 33%" })
hl.bind("SUPER + SHIFT + X", function()
    scrolling.col_set(1.0)
end, { submap_universal = true, description = "Column: Set column width to 100%" })


hl.bind("SUPER + ALT + mouse_up", hl.dsp.window.resize({ x = 100, y = 0, relative = true }),
    { submap_universal = true, description = "Resize: Resize window wider (100px)" })
hl.bind("SUPER + ALT + mouse_down", hl.dsp.window.resize({ x = -100, y = 0, relative = true }),
    { submap_universal = true, description = "Resize: Resize window narrower (100px)" })

hl.bind("SUPER + bracketleft", function()
    scrolling.move_flow("back")
end, { description = "Move: Move window back in the scroll flow" })
hl.bind("SUPER + bracketright", function()
    scrolling.move_flow("forward")
end, { description = "Move: Move window forward in the scroll flow" })

hl.bind("SUPER + SHIFT + mouse_up", function()
    scrolling.move_flow("back")
end, { description = "Move: Move window back in the scroll flow" })
hl.bind("SUPER + SHIFT + mouse_down", function()
    scrolling.move_flow("forward")
end, { description = "Move: Move window forward in the scroll flow" })

hl.bind("SUPER + L", function()
    scrolling.toggle_layout()
end, { description = "Column: Toggle scrolling / dwindle layout" })

local scrolloverview = hl.plugin and hl.plugin.scrolloverview
if scrolloverview then
    hl.bind("SUPER + TAB", scrolloverview.overview("toggle"),
        { description = "Workspace: Toggle workspace overview" })
end

hl.bind("SUPER + ALT + S", hl.dsp.window.resize({ x = 0, y = 50, relative = true }),
    { repeating = true, submap_universal = true, description = "Resize: Resize window taller (50px)" })
hl.bind("SUPER + ALT + W", hl.dsp.window.resize({ x = 0, y = -50, relative = true }),
    { repeating = true, submap_universal = true, description = "Resize: Resize window shorter (50px)" })
hl.bind("SUPER + ALT + A", hl.dsp.window.resize({ x = -50, y = 0, relative = true }),
    { repeating = true, submap_universal = true, description = "Resize: Resize window narrower (50px)" })
hl.bind("SUPER + ALT + D", hl.dsp.window.resize({ x = 50, y = 0, relative = true }),
    { repeating = true, submap_universal = true, description = "Resize: Resize window wider (50px)" })
hl.bind("SUPER + ALT + Up", hl.dsp.window.resize({ x = 0, y = -50, relative = true }),
    { repeating = true, submap_universal = true, description = "Resize: Resize window shorter (50px)" })
hl.bind("SUPER + ALT + Down", hl.dsp.window.resize({ x = 0, y = 50, relative = true }),
    { repeating = true, submap_universal = true, description = "Resize: Resize window taller (50px)" })
hl.bind("SUPER + ALT + Left", hl.dsp.window.resize({ x = -50, y = 0, relative = true }),
    { repeating = true, submap_universal = true, description = "Resize: Resize window narrower (50px)" })
hl.bind("SUPER + ALT + Right", hl.dsp.window.resize({ x = 50, y = 0, relative = true }),
    { repeating = true, submap_universal = true, description = "Resize: Resize window wider (50px)" })

local ZOOM_MAX = 10

local function zoom_by(delta)
    return function()
        local zoom = hl.get_config("cursor.zoom_factor") or 1
        hl.config({ cursor = { zoom_factor = math.min(ZOOM_MAX, math.max(1, zoom + delta)) } })
    end
end

hl.bind("SUPER + CTRL + X", zoom_by(0.5), { repeating = true, description = "System: Zoom screen in" })
hl.bind("SUPER + CTRL + Z", zoom_by(-0.5), { repeating = true, description = "System: Zoom screen out" })
hl.bind("SUPER + CTRL + ALT + Z", function()
    hl.config({ cursor = { zoom_factor = 1 } })
end, { description = "System: Reset screen zoom" })

hl.bind("SUPER + CTRL + mouse_up", zoom_by(0.25), { description = "System: Zoom screen in" })
hl.bind("SUPER + CTRL + mouse_down", zoom_by(-0.25), { description = "System: Zoom screen out" })

hl.bind("Print", hl.dsp.exec_cmd("noctalia msg screenshot-region"), { description = "Capture: Screenshot a region" })
hl.bind("SUPER + Print", screen_toolkit.toggle, { description = "Capture: Toggle screen recording" })
hl.bind("ALT + Print", hl.dsp.exec_cmd("noctalia msg screenshot-fullscreen pick"),
    { description = "Capture: Screenshot a monitor (pick)" })
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("noctalia msg screenshot-fullscreen"),
    { description = "Capture: Screenshot the focused monitor" })

hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Window: Drag window" })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(),
    { mouse = true, submap_universal = true, description = "Window: Resize window by dragging" })
hl.bind("SUPER + mouse:274", windows.pop,
    { mouse = true, description = "Window: Float window out, centred and pinned" })
hl.bind("SUPER + CTRL + mouse:274", scrolling.col_maximize,
    { mouse = true, description = "Column: Maximize column width (toggle)" })
hl.bind("SUPER + ALT + mouse:274", function()
    scrolling.col_step("up", true)
end, { mouse = true, description = "Column: Cycle column width presets" })

hl.bind("SUPER + mouse:275", function()
    scrolling.move_flow("forward")
end, { mouse = true, description = "Move: Move window forward in the scroll flow" })
hl.bind("SUPER + mouse:276", function()
    scrolling.move_flow("back")
end, { mouse = true, description = "Move: Move window back in the scroll flow" })

hl.bind("SUPER + mouse_down", function()
    scrolling.wheel_focus("up")
end, { description = "Focus: Focus next window" })
hl.bind("SUPER + mouse_up", function()
    scrolling.wheel_focus("down")
end, { description = "Focus: Focus previous window" })



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
                local direction = monitor and monitor.transform % 2 == 1 and portrait_direction or landscape_direction
                scrolloverview.navigate(direction)
            end
        end

        hl.bind("SUPER + mouse_up", navigate_overview_wheel("up", "left"),
            { description = "Navigate back" })
        hl.bind("SUPER + mouse_down", navigate_overview_wheel("down", "right"),
            { description = "Navigate forward" })

        for i = 1, 10 do
            local idx = i
            local key = (i == 10) and "0" or tostring(i)
            hl.bind("SUPER + " .. key, function()
                workspaces.focus(idx)
            end, { description = "Workspace: Focus workspace " .. idx })
        end

        hl.bind("SUPER + TAB", scrolloverview.overview("off"), { description = "Close overview" })
        hl.bind("Return", scrolloverview.overview("select"), { description = "Select workspace" })
        hl.bind("Escape", scrolloverview.overview("off"), { description = "Close overview" })
        hl.bind("SUPER + mouse:272", hl.dsp.window.drag(),
            { mouse = true, submap_universal = true, description = "Window: Drag window" })
        hl.bind("mouse:272", function()
            scrolloverview.overview("select")
            scrolloverview.window("select")
            scrolloverview.overview("off")
        end, { mouse = true, description = "Select window" })
        hl.bind("mouse:274", scrolloverview.window("close"), { mouse = true, description = "Window: Close window" })
    end)
end

define_scrolloverview_submap()
