local policy = require("scripts.monitor_policy")

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
local SPEED = 1.35
local DURATION_SCALE = 1.15

local function duration(ds)
    return math.floor(ds / SPEED * 100 + 0.5) / 100 * DURATION_SCALE
end

local function spring(name, stiffness)
    local k = stiffness * SPEED * SPEED / DURATION_SCALE ^ 2
    hl.curve(name, {
        type = "spring",
        mass = 1,
        stiffness = k,
        dampening = 2 * math.sqrt(k),
    })
end

hl.curve("niriExpo", {
    type = "bezier",
    points = {
        { 0.16, 1.0 },
        { 0.30, 1.0 },
    },
})

hl.curve("niriQuad", {
    type = "bezier",
    points = {
        { 0.50, 1.0 },
        { 0.89, 1.0 },
    },
})

spring("niriWorkspace", 8500)
spring("niriOverview", 4800 / 1.2 ^ 2)

hl.animation({
    leaf = "global",
    enabled = true,
    speed = duration(2.5),
    bezier = "niriExpo",
})

hl.animation({
    leaf = "windowsIn",
    enabled = true,
    speed = 1.5,
    bezier = "easeOutQuint",
    style = "popin 87%",
})

hl.animation({
    leaf = "windowsMove",
    enabled = true,
    speed = duration(1),
    spring = "niriOverview",
})

hl.animation({
    leaf = "windowsOut",
    enabled = true,
    speed = DURATION_SCALE,
    bezier = "linear",
    style = "popin 87%",
})

hl.animation({
    leaf = "fadeIn",
    enabled = true,
    speed = duration(1.8),
    bezier = "niriExpo",
})

hl.animation({
    leaf = "fadeOut",
    enabled = true,
    speed = duration(1.8),
    bezier = "niriQuad",
})

local ws_anim = {
    leaf = "workspaces",
    enabled = false,
    speed = 1,
    spring = "niriWorkspace",
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
    move_timer = hl.timer(reset_workspace_animation, { timeout = 300, type = "oneshot" })
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

hl.animation({
    leaf = "layersIn",
    enabled = true,
    speed = 0.3 * DURATION_SCALE,
    bezier = "niriExpo",
})

hl.animation({
    leaf = "layersOut",
    enabled = true,
    speed = 0.5 * DURATION_SCALE,
    bezier = "niriQuad",
})

hl.animation({
    leaf = "fadeLayersIn",
    enabled = true,
    speed = 0.3 * DURATION_SCALE,
    bezier = "niriExpo",
})

hl.animation({
    leaf = "fadeLayersOut",
    enabled = true,
    speed = 0.5 * DURATION_SCALE,
    bezier = "niriQuad",
})

hl.animation({
    leaf = "border",
    enabled = true,
    speed = duration(1),
    bezier = "default",
})

return {
    sync_workspace_axis = reset_workspace_animation,
    animate_workspace_move = animate_workspace_move,
}
