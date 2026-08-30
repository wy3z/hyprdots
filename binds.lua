local scrolling = require("scripts.scrolling")
local workspaces = require("scripts.workspaces")
local voxtype = require("scripts.voxtype")
local screen_toolkit = require("scripts.screen_toolkit")

-- Reload / quit
hl.bind("SUPER + CTRL + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind("SUPER + CTRL + SHIFT + E", hl.dsp.exit())

-- Apps
hl.bind("SUPER + Return", hl.dsp.exec_cmd("ghostty +new-window"))
hl.bind("SUPER + E", hl.dsp.exec_cmd("nautilus"))
hl.bind("SUPER + B", hl.dsp.exec_cmd("helium-browser"))
hl.bind("SUPER + N", hl.dsp.exec_cmd("iotas"))

-- Shell
hl.bind("SUPER + Space", hl.dsp.exec_cmd("vicinae toggle"))
hl.bind("SUPER + V", hl.dsp.exec_cmd("noctalia msg panel-toggle clipboard"))
hl.bind("SUPER + comma", hl.dsp.exec_cmd("noctalia msg settings-toggle"))
hl.bind("SUPER + I", hl.dsp.exec_cmd("noctalia msg panel-toggle nightwatch75/todo:panel"))
hl.bind("SUPER + J", hl.dsp.exec_cmd("noctalia msg panel-toggle control-center notifications"))
hl.bind("SUPER + M", hl.dsp.exec_cmd("noctalia msg panel-toggle control-center system"))
hl.bind("SUPER + Y", hl.dsp.exec_cmd("noctalia msg panel-toggle wallpaper"))
hl.bind("CTRL + SUPER + B", hl.dsp.exec_cmd("noctalia msg bar-toggle Island"))
hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd("noctalia msg panel-toggle control-center system"))
hl.bind("CTRL + SHIFT + SUPER + L", hl.dsp.exec_cmd("noctalia msg session lock"))
hl.bind("SUPER + Z", hl.dsp.exec_cmd("noctalia msg panel-toggle session"))
hl.bind("ALT + Tab", hl.dsp.exec_cmd("noctalia msg window-switcher"))

-- Dictation hybrid: tap to toggle, or hold to talk and stop on release.
-- Let Alt settle before stopping so synthetic output spaces cannot retrigger
-- this binding while the modifier is still logically held.
hl.bind("ALT + Space", voxtype.press, { description = "Voxtype tap/hold start" })
hl.bind("ALT + Space", voxtype.release, { release = true, description = "Voxtype hold release" })


-- Audio, media and brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("noctalia msg volume-up"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("noctalia msg volume-down"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("noctalia msg volume-mute"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("noctalia msg mic-mute"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("noctalia msg media toggle"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("noctalia msg media toggle"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("noctalia msg media next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("noctalia msg media previous"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("noctalia msg brightness-up"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("noctalia msg brightness-down"), { locked = true, repeating = true })

-- Window state
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + SHIFT + T", hl.dsp.window.pin())
hl.bind("SUPER + C", hl.dsp.window.center())
hl.bind("SUPER + ALT + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
hl.bind("SUPER + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))

-- Focus
hl.bind("SUPER + A", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + S", hl.dsp.focus({ direction = "down" }))
hl.bind("SUPER + W", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + D", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + Left", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + Down", hl.dsp.focus({ direction = "down" }))
hl.bind("SUPER + Up", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + Right", hl.dsp.focus({ direction = "right" }))

-- Move / swap
hl.bind("SUPER + SHIFT + A", hl.dsp.window.move({ direction = "l" }))
hl.bind("SUPER + SHIFT + S", hl.dsp.window.move({ direction = "d" }))
hl.bind("SUPER + SHIFT + W", hl.dsp.window.move({ direction = "u" }))
hl.bind("SUPER + SHIFT + D", hl.dsp.window.move({ direction = "r" }))
hl.bind("SUPER + SHIFT + Left", hl.dsp.window.move({ direction = "l" }))
hl.bind("SUPER + SHIFT + Down", hl.dsp.window.move({ direction = "d" }))
hl.bind("SUPER + SHIFT + Up", hl.dsp.window.move({ direction = "u" }))
hl.bind("SUPER + SHIFT + Right", hl.dsp.window.move({ direction = "r" }))

-- Workspaces
for i = 1, 10 do
    local idx = i
    local key = (i == 10) and "0" or tostring(i)
    hl.bind("SUPER + " .. key, function() workspaces.focus(idx) end)
    hl.bind("SUPER + SHIFT + " .. key, function() workspaces.move(idx) end)
end
hl.bind("SUPER + U", function() workspaces.cycle("next") end)
hl.bind("SUPER + Page_Down", function() workspaces.cycle("next") end)
hl.bind("SUPER + Page_Up", function() workspaces.cycle("prev") end)

hl.bind("SUPER + SHIFT + E", workspaces.move_to_empty)

-- Monitors
hl.bind("SUPER + CTRL + Left", hl.dsp.focus({ monitor = "l" }))
hl.bind("SUPER + CTRL + Right", hl.dsp.focus({ monitor = "r" }))
hl.bind("SUPER + Home", hl.dsp.focus({ monitor = "l" }))
hl.bind("SUPER + End", hl.dsp.focus({ monitor = "r" }))
hl.bind("SUPER + SHIFT + CTRL + A", hl.dsp.window.move({ monitor = "l" }))
hl.bind("SUPER + SHIFT + CTRL + D", hl.dsp.window.move({ monitor = "r" }))
hl.bind("SUPER + SHIFT + CTRL + Left", hl.dsp.window.move({ monitor = "l" }))
hl.bind("SUPER + SHIFT + CTRL + Right", hl.dsp.window.move({ monitor = "r" }))
hl.bind("SUPER + SHIFT + CTRL + 1", hl.dsp.window.move({ monitor = "desc:Dell Inc. DELL U2717D T4F1X621218S" }))
hl.bind("SUPER + SHIFT + CTRL + 2", hl.dsp.window.move({ monitor = "desc:Dell Inc. DELL S2721DGF 3QWBP83" }))

hl.bind("SUPER + SHIFT + Tab", hl.dsp.window.move({ monitor = "+1" }))

-- Scrolling layout
hl.bind("SUPER + F", function()
    scrolling.col_toggle(0.5, 1.0)
end) -- 50% <-> 100%
hl.bind("SUPER + R", function()
    scrolling.col_toggle(0.333, 0.75)
end) -- 33% <-> 75%


hl.bind("SUPER + ALT + equal", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + ALT + minus", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + ALT + mouse_up", hl.dsp.window.resize({ x = 100, y = 0, relative = true }))
hl.bind("SUPER + ALT + mouse_down", hl.dsp.window.resize({ x = -100, y = 0, relative = true }))
hl.bind("SUPER + ALT + CTRL + equal", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })
    hl.bind("SUPER + ALT + CTRL + minus", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
    
    hl.bind("SUPER + bracketleft", function()
        scrolling.move_flow("back")
    end)
    hl.bind("SUPER + bracketright", function()
        scrolling.move_flow("forward")
    end)
    
    -- Layout toggle
    hl.bind("SUPER + L", function()
        scrolling.toggle_layout()
    end)
    
    -- Overview / window cycling
local scrolloverview = hl.plugin and hl.plugin.scrolloverview
if scrolloverview then
    hl.bind("SUPER + TAB", scrolloverview.overview("toggle"))
end

-- Resize
hl.bind("SUPER + ALT + S", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })
hl.bind("SUPER + ALT + W", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
hl.bind("SUPER + ALT + A", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + ALT + D", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + ALT + Up", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
hl.bind("SUPER + ALT + Down", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })
hl.bind("SUPER + ALT + Left", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + ALT + Right", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })

-- Screenshots
hl.bind("Print", hl.dsp.exec_cmd("noctalia msg screenshot-region"))
hl.bind("CTRL + Print", screen_toolkit.toggle)
hl.bind("ALT + Print", hl.dsp.exec_cmd("noctalia msg screenshot-fullscreen pick"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("noctalia msg screenshot-fullscreen"))

-- Mouse drag
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind("SUPER + mouse:274", hl.dsp.window.float({ action = "toggle" }), { mouse = true })
hl.bind("SUPER + CTRL + mouse:274", function()
    scrolling.col_toggle(0.5, 1.0)
end, { mouse = true }) -- 50% <-> 100%
hl.bind("SUPER + ALT + mouse:274", function()
    scrolling.col_toggle(0.333, 0.75)
end, { mouse = true }) -- 33% <-> 75%

hl.bind("SUPER + mouse:275", function()
    scrolling.move_flow("forward")
end, { mouse = true })
hl.bind("SUPER + mouse:276", function()
    scrolling.move_flow("back")
end, { mouse = true })

-- Wheel
hl.bind("SUPER + mouse_down", function()
    scrolling.wheel_focus("up")
end)
hl.bind("SUPER + mouse_up", function()
    scrolling.wheel_focus("down")
end)

hl.bind("SUPER + SHIFT + mouse_up", function()
    scrolling.move_flow("back")
end)
hl.bind("SUPER + SHIFT + mouse_down", function()
    scrolling.move_flow("forward")
end)

-- Scroll overview
local function define_scrolloverview_submap()
    local scrolloverview = hl.plugin and hl.plugin.scrolloverview
    if not scrolloverview then
        return
    end

    hl.define_submap("scrolloverview", function()
        hl.bind("Left", scrolloverview.navigate("left"))
        hl.bind("Right", scrolloverview.navigate("right"))
        hl.bind("Up", scrolloverview.navigate("up"))
        hl.bind("Down", scrolloverview.navigate("down"))
        local function navigate_overview_wheel(portrait_direction, landscape_direction)
            return function()
                local monitor = hl.get_active_monitor()
                local direction = monitor and monitor.transform % 2 == 1 and portrait_direction or landscape_direction
                scrolloverview.navigate(direction)
            end
        end

        hl.bind("SUPER + mouse_up", navigate_overview_wheel("up", "left"))
        hl.bind("SUPER + mouse_down", navigate_overview_wheel("down", "right"))

        for i = 1, 10 do
            local idx = i
            local key = (i == 10) and "0" or tostring(i)
            hl.bind("SUPER + " .. key, function()
                workspaces.focus(idx)
            end)
        end

        hl.bind("SUPER + TAB", scrolloverview.overview("off"))
        hl.bind("Return", scrolloverview.overview("select"))
        hl.bind("Escape", scrolloverview.overview("off"))
        hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true, submap_universal = true })
        hl.bind("mouse:272", function()
            scrolloverview.overview("select")
            scrolloverview.window("select")
            scrolloverview.overview("off")
        end, { mouse = true })
        hl.bind("mouse:274", scrolloverview.window("close"), { mouse = true })
    end)
end

define_scrolloverview_submap()
