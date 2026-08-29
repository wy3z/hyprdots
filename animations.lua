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

hl.curve("niriMove", {
    type = "spring",
    mass = 1,
    stiffness = 1800,
    dampening = 84.8528,
})

hl.curve("niriWorkspace", {
    type = "spring",
    mass = 1,
    stiffness = 2200,
    dampening = 93.8083,
})

hl.animation({
    leaf = "windowsIn",
    enabled = true,
    speed = 1,
    spring = "niriMove",
    style = "slide",
})

hl.animation({
    leaf = "windowsMove",
    enabled = true,
    speed = 1,
    spring = "niriMove",
})

hl.animation({
    leaf = "windowsOut",
    enabled = true,
    speed = 1.5,
    bezier = "niriQuad",
    style = "slide",
})

hl.animation({
    leaf = "fadeIn",
    enabled = true,
    speed = 1.5,
    bezier = "niriExpo",
})

hl.animation({
    leaf = "fadeOut",
    enabled = true,
    speed = 1.5,
    bezier = "niriQuad",
})

local ws_anim = {
    leaf = "workspaces",
    enabled = true,
    speed = 1,
    spring = "niriWorkspace",
    style = "slidevert",
}

hl.animation(ws_anim)

local function apply_ws_anim_axis(m)
    m = m or hl.get_active_monitor()
    if not m then return end

    local width, height = m.width, m.height
    if m.transform % 2 == 1 then width, height = height, width end
    ws_anim.style = (height > width) and "slide" or "slidevert"
    hl.animation(ws_anim)
end

-- Avoid stacking subscriptions across config reloads.
if _G.__ws_anim_sub then _G.__ws_anim_sub:remove() end
_G.__ws_anim_sub = hl.on("monitor.focused", apply_ws_anim_axis)

-- Monitor metadata may not exist during initial evaluation.
hl.timer(apply_ws_anim_axis, { timeout = 500, type = "oneshot" })

hl.animation({
    leaf = "layersIn",
    enabled = true,
    speed = 0.8,
    bezier = "niriExpo",
})

hl.animation({
    leaf = "layersOut",
    enabled = true,
    speed = 0.6,
    bezier = "niriQuad",
})

hl.animation({
    leaf = "border",
    enabled = true,
    speed = 1,
    bezier = "default",
})
