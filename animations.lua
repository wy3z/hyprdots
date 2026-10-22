local policy = require("scripts.monitor_policy")

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("closeEase", { type = "bezier", points = { { 0.4, 0 }, { 1, 1 } } })

-- SwiftUI-style spring: response is the perceived duration in seconds, damping is
-- dampingFraction (1 = no bounce). Hyprland springs run in real time, so speed is ignored.
local function spring(name, response, damping)
    hl.curve(name, {
        type = "spring",
        mass = 1,
        stiffness = (2 * math.pi / response) ^ 2,
        dampening = 4 * math.pi * damping / response,
    })
end

spring("macSnappy", 0.15, 0.86)
spring("macSmooth", 0.12, 0.95)
spring("macWorkspace", 0.14, 0.92)

for _, animation in ipairs({
    { leaf = "global", enabled = true, speed = 1.5, bezier = "default" },
    { leaf = "border", enabled = true, speed = 1.2, bezier = "easeOutQuint" },
    { leaf = "windows", enabled = true, speed = 1.5, spring = "macSnappy" },
    { leaf = "windowsMove", enabled = true, speed = 1.5, spring = "macSnappy" },
    { leaf = "windowsIn", enabled = true, speed = 1.5, spring = "macSnappy", style = "popin 90%" },
    { leaf = "windowsOut", enabled = true, speed = 1, bezier = "closeEase", style = "popin 92%" },
    { leaf = "fadeIn", enabled = true, speed = 1.5, spring = "macSmooth" },
    { leaf = "fadeOut", enabled = true, speed = 1, bezier = "closeEase" },
    { leaf = "fade", enabled = true, speed = 1.5, spring = "macSmooth" },
    { leaf = "layers", enabled = true, speed = 1.5, spring = "macSmooth" },
    { leaf = "layersIn", enabled = true, speed = 1.5, spring = "macSmooth", style = "fade" },
    { leaf = "layersOut", enabled = true, speed = 1, bezier = "closeEase", style = "fade" },
    { leaf = "fadeLayersIn", enabled = true, speed = 1.5, spring = "macSmooth" },
    { leaf = "fadeLayersOut", enabled = true, speed = 1, bezier = "closeEase" },
    { leaf = "zoomFactor", enabled = true, speed = 1.5, spring = "macSmooth" },
}) do
    hl.animation(animation)
end

local ws_anim = {
    leaf = "workspaces",
    enabled = false,
    speed = 1,
    spring = "macWorkspace",
    style = "slidevert",
}

hl.animation(ws_anim)

local function apply_ws_anim_axis(m)
    if not m or not m.width or not m.height or not m.transform then
        m = hl.get_active_monitor()
    end
    if not m or not m.width or not m.height or not m.transform then return end

    ws_anim.style = policy.is_portrait(m) and "slide" or "slidevert"
    hl.animation(ws_anim)
end

local move_timer
local function reset_workspace_animation(m)
    if move_timer then
        move_timer:set_enabled(false)
        move_timer = nil
    end
    ws_anim.enabled = false
    apply_ws_anim_axis(m)
end

local function animate_workspace_move(move)
    if hl.get_current_submap() == "scrolloverview" then return move() end
    if move_timer then move_timer:set_enabled(false) end
    ws_anim.enabled = true
    apply_ws_anim_axis()
    move_timer = hl.timer(reset_workspace_animation, { timeout = 400, type = "oneshot" })
    move()
end

local retry_timer
local function sync_ws_anim_axis(m)
    apply_ws_anim_axis(m)
    if retry_timer then retry_timer:set_enabled(false) end
    retry_timer = hl.timer(function()
        retry_timer = nil
        apply_ws_anim_axis()
    end, { timeout = 20, type = "oneshot" })
end

hl.on("monitor.focused", sync_ws_anim_axis)
hl.on("monitor.layout_changed", sync_ws_anim_axis)

hl.timer(sync_ws_anim_axis, { timeout = 500, type = "oneshot" })

return {
    sync_workspace_axis = reset_workspace_animation,
    animate_workspace_move = animate_workspace_move,
}
