-- =====================================================================
-- Binds
-- =====================================================================

-- Hyprland keybinds. Non-trivial bind actions live in scripts.lua (act.*).
local act = require("scripts")

-- === Reload / quit ===
hl.bind("SUPER + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind("SUPER + SHIFT + E", hl.dsp.exit())

-- === Apps ===
hl.bind("SUPER + Return", hl.dsp.exec_cmd("ghostty"))
hl.bind("SUPER + E", hl.dsp.exec_cmd("dolphin"))
hl.bind("SUPER + B", hl.dsp.exec_cmd("helium-browser"))

-- === Noctalia shell (v5 IPC: `noctalia msg`) ===
hl.bind("SUPER + Space", hl.dsp.exec_cmd("vicinae toggle"))
hl.bind("SUPER + V", hl.dsp.exec_cmd("noctalia msg panel-toggle clipboard"))
hl.bind("SUPER + comma", hl.dsp.exec_cmd("noctalia msg settings-toggle"))
hl.bind("SUPER + N", hl.dsp.exec_cmd("noctalia msg panel-toggle control-center notifications"))
hl.bind("SUPER + M", hl.dsp.exec_cmd("noctalia msg panel-toggle control-center system"))
hl.bind("SUPER + Y", hl.dsp.exec_cmd("noctalia msg panel-toggle wallpaper"))
hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd("noctalia msg bar-toggle"))
hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd("noctalia msg panel-toggle control-center system"))
hl.bind("CTRL + SHIFT + SUPER + L", hl.dsp.exec_cmd("noctalia msg session lock"))
hl.bind("SUPER + X", hl.dsp.exec_cmd("noctalia msg panel-toggle session"))

-- === Audio / media / brightness ===
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("noctalia msg volume-up"),
    { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("noctalia msg volume-down"),
    { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("noctalia msg volume-mute"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("noctalia msg mic-mute"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("noctalia msg media toggle"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("noctalia msg media toggle"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("noctalia msg media next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("noctalia msg media previous"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("noctalia msg brightness-up"),
    { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("noctalia msg brightness-down"),
    { locked = true, repeating = true })

-- === Window lifecycle / state ===
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + SHIFT + T", hl.dsp.window.pin()) -- pin (floating only)
hl.bind("SUPER + C", hl.dsp.window.center())
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
hl.bind("SUPER + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))

-- === Focus (vim + arrows) ===
hl.bind("SUPER + H", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + J", hl.dsp.focus({ direction = "down" }))
hl.bind("SUPER + K", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + L", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + Left", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + Down", hl.dsp.focus({ direction = "down" }))
hl.bind("SUPER + Up", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + Right", hl.dsp.focus({ direction = "right" }))

-- === Move / swap (vim + arrows) ===
hl.bind("SUPER + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind("SUPER + SHIFT + J", hl.dsp.window.move({ direction = "d" }))
hl.bind("SUPER + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind("SUPER + SHIFT + L", hl.dsp.window.move({ direction = "r" }))
hl.bind("SUPER + SHIFT + Left", hl.dsp.window.move({ direction = "l" }))
hl.bind("SUPER + SHIFT + Down", hl.dsp.window.move({ direction = "d" }))
hl.bind("SUPER + SHIFT + Up", hl.dsp.window.move({ direction = "u" }))
hl.bind("SUPER + SHIFT + Right", hl.dsp.window.move({ direction = "r" }))

-- === Workspaces 1-10 (per-monitor via split-monitor-workspaces; native fallback) ===
act.bind_workspaces() -- see scripts.lua

-- === Monitor focus / move ===
hl.bind("SUPER + CTRL + H", hl.dsp.focus({ monitor = "l" }))
hl.bind("SUPER + CTRL + L", hl.dsp.focus({ monitor = "r" }))
hl.bind("SUPER + CTRL + Left", hl.dsp.focus({ monitor = "l" }))
hl.bind("SUPER + CTRL + Right", hl.dsp.focus({ monitor = "r" }))
hl.bind("SUPER + SHIFT + CTRL + H", hl.dsp.window.move({ monitor = "l" }))
hl.bind("SUPER + SHIFT + CTRL + L", hl.dsp.window.move({ monitor = "r" }))
hl.bind("SUPER + SHIFT + CTRL + Left", hl.dsp.window.move({ monitor = "l" }))
hl.bind("SUPER + SHIFT + CTRL + Right", hl.dsp.window.move({ monitor = "r" }))
hl.bind("SUPER + CTRL + 1", hl.dsp.window.move({ monitor = "HDMI-A-2" }))
hl.bind("SUPER + CTRL + 2", hl.dsp.window.move({ monitor = "DP-5" }))
-- Send window to the OTHER monitor (mon:+1 toggles with two outputs). Unlike a
-- mouse drag, this lands it as a NEW column rather than consuming it into the
-- column under the cursor (skips the scrolling layout's drag-admit path).
hl.bind("SUPER + SHIFT + Tab", hl.dsp.window.move({ monitor = "+1" }))

-- === Column / scroller (native "scrolling" layout) ===
-- act.scroller_msg guards on the scrolling layout (colresize/consume/expel error
-- on master/dwindle) and no-ops elsewhere. See scripts.lua.
hl.bind("SUPER + R", function() act.scroller_msg("colresize +conf") end) -- cycle preset column widths
hl.bind("SUPER + equal", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + minus", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + SHIFT + equal", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })
hl.bind("SUPER + SHIFT + minus", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
-- niri-style flow: slide the window within its row, then cross to the next row at
-- the edge (back = left/consume, forward = right/expel). See act.move_flow.
hl.bind("SUPER + bracketleft", function() act.move_flow("back") end)
hl.bind("SUPER + bracketright", function() act.move_flow("forward") end)

-- === Layout toggle (active workspace: dwindle <-> scrolling, in place) ===
hl.bind("SUPER + S", function() act.toggle_layout() end)

-- === Overview / window cycling ===
hl.bind("SUPER + TAB", function()
    local hymission = hl.plugin and hl.plugin.hymission
    if not hymission or not act.has_hymission_windows() then return end

    act.hymission_sync()
    hymission.toggle()
end)
hl.bind("ALT + Tab", hl.dsp.window.cycle_next({ next = true }))
hl.bind("ALT + SHIFT + Tab", hl.dsp.window.cycle_next({ prev = true }))

-- === Floating window move/resize ===
hl.bind("SUPER + ALT + K", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
hl.bind("SUPER + ALT + J", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })
hl.bind("SUPER + ALT + H", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + ALT + L", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + ALT + Up", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
hl.bind("SUPER + ALT + Down", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })
hl.bind("SUPER + ALT + Left", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + ALT + Right", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })

-- === Screenshots (Noctalia v5 IPC) ===
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("noctalia msg screenshot-region"))
hl.bind("Print", hl.dsp.exec_cmd("noctalia msg screenshot-fullscreen"))             -- focused monitor
hl.bind("CTRL + Print", hl.dsp.exec_cmd("noctalia msg screenshot-fullscreen pick")) -- multi-monitor picker
hl.bind("ALT + Print", hl.dsp.exec_cmd("noctalia msg screenshot-region"))

-- === Mouse drag === (mouse-button binds need { mouse = true })
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
-- Side buttons -> same niri-style flow as SUPER + [ / ] (see act.move_flow):
-- slide within the row, cross to the next/prev row at the edge, expel into a
-- full-width row at the very top/bottom. Swap if inverted.
hl.bind("SUPER + mouse:275", function() act.move_flow("forward") end, { mouse = true })
hl.bind("SUPER + mouse:276", function() act.move_flow("back") end, { mouse = true })

-- === Wheel (axisbind) ===
-- Layout-aware focus along the wheel (scrolling layout = step the tape & clamp;
-- dwindle/master = cycle all windows, wraps). See act.wheel_focus in scripts.lua.
hl.bind("SUPER + mouse_up", function() act.wheel_focus("up") end)
hl.bind("SUPER + mouse_down", function() act.wheel_focus("down") end)
hl.bind("SUPER + CTRL + mouse_up", hl.dsp.focus({ monitor = "l" }))
hl.bind("SUPER + CTRL + mouse_down", hl.dsp.focus({ monitor = "r" }))
hl.bind("SUPER + ALT + mouse_up", hl.dsp.window.resize({ x = 100, y = 0, relative = true }), { repeating = false })
hl.bind("SUPER + ALT + mouse_down", hl.dsp.window.resize({ x = -100, y = 0, relative = true }), { repeating = false })
hl.bind("SUPER + ALT + CTRL + mouse_up", hl.dsp.window.resize({ x = 0, y = 100, relative = true }), { repeating = false })
hl.bind("SUPER + ALT + CTRL + mouse_down", hl.dsp.window.resize({ x = 0, y = -100, relative = true }),
    { repeating = false })
-- swapcol moves the column toward the end of the tape (scroll up = next/right).
hl.bind("SUPER + SHIFT + mouse_down", function() act.move_flow("back") end)
hl.bind("SUPER + SHIFT + mouse_up", function() act.move_flow("forward") end)
