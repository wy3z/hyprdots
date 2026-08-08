hl.curve("niriExpo", { type = "bezier", points = { { 0.16, 1.0 }, { 0.30, 1.0 } } }) -- ease-out-expo
hl.curve("niriQuad", { type = "bezier", points = { { 0.50, 1.0 }, { 0.89, 1.0 } } }) -- ease-out-quad
hl.curve("niriCubic", { type = "bezier", points = { { 0.33, 1.0 }, { 0.68, 1.0 } } }) -- ease-out-cubic
hl.curve("niriSpring", { type = "spring", mass = 1, stiffness = 675, dampening = 39 })
hl.curve("niriSpringFast", { type = "spring", mass = 1, stiffness = 900, dampening = 48 })

hl.animation({ leaf = "windowsIn", enabled = true, speed = 1.2, bezier = "niriExpo", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.2, bezier = "niriQuad", style = "slide" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 2.4, spring = "niriSpring" })
hl.animation({ leaf = "fade", enabled = true, speed = 1.2, bezier = "niriQuad" })


local ws_anim = { leaf = "workspaces", enabled = true, speed = 2.0, spring = "niriSpringFast", style = "slide" }
hl.animation(ws_anim)
local function apply_ws_anim_axis(m)
    m = m or hl.get_active_monitor()
    if not m then return end
    local ew, eh = m.width, m.height
    if m.transform % 2 == 1 then ew, eh = m.height, m.width end
    ws_anim.style = (eh > ew) and "slide" or "slidevert"
    hl.animation(ws_anim)
end
if _G.__ws_anim_sub then _G.__ws_anim_sub:remove() end
_G.__ws_anim_sub = hl.on("monitor.focused", apply_ws_anim_axis)
-- Monitors are not ready during initial config evaluation.
hl.timer(function() apply_ws_anim_axis() end, { timeout = 500, type = "oneshot" })

hl.animation({ leaf = "layersIn", enabled = true, speed = 0.8, bezier = "niriExpo" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 0.6, bezier = "niriQuad" })
hl.animation({ leaf = "border", enabled = true, speed = 1, bezier = "default" })
