hl.window_rule({ match = { class = "^(org\\.gnome\\.)" }, border_size = 0 })
hl.window_rule({ match = { class = "^(org\\.gnome\\.Calculator)$" }, float = true })
hl.window_rule({ match = { class = "^(zoom)$" }, float = true })
hl.window_rule({ match = { float = false }, no_shadow = false })
hl.window_rule({
    match  = { class = "(?i)^(xdg-desktop-portal-gtk)$" },
    float  = true,
    -- Portrait monitors are only ~1440 wide; use a wider fraction there.
    size   = { "((monitor_h>monitor_w) ? monitor_w*0.85 : monitor_w*0.5)", "(monitor_h*0.55)" },
    center = true,
    no_blur     = true,
    no_shadow   = true,
    border_size = 0,
})

-- Helium PWAs set WM_WINDOW_ROLE=pop-up, so Hyprland auto-floats them.
-- Force-tile Helium windows; Bitwarden popup is re-floated by title below.
hl.window_rule({
    match = { class = "^(Helium)$" },
    float = false,
})
hl.window_rule({
    match       = { title = "^(Bitwarden)$" },
    float       = true,
    border_size = 0,
})
hl.window_rule({
    match       = { class = "^(com\\.gabm\\.satty)$" },
    float       = true,
    border_size = 0,
    center      = true,
})

hl.window_rule({
    match  = { class = "^(org\\.gnome\\.NautilusPreviewer)$" },
    float  = true,
    size   = { "((monitor_h>monitor_w) ? monitor_w*0.85 : monitor_w*0.5)", "(monitor_h*0.6)" },
    center = true,
})

hl.window_rule({ match = { float = true }, animation = "popin 80%" })

-- Codex floating overlays: pet/voice window and browser-view animate comments.
-- The animate overlay ("Browser comment") is translucent and picks up compositor
-- blur without no_blur. Match both floating codex windows and the title itself.
hl.window_rule({
    match       = { class = "^codex-desktop$", float = true },
    border_size = 0,
    no_shadow   = true,
    no_blur     = true,
})
hl.window_rule({
    match       = { class = "^codex-desktop$", title = "^(Browser comment)$" },
    border_size = 0,
    no_shadow   = true,
    no_blur     = true,
})
hl.window_rule({
    match = { class = "^codex-desktop$", title = "^Codex$" },
    float = true,
})

-- Avoid blurring translucent XWayland menu margins.
hl.window_rule({
    match = { xwayland = true, float = true, class = "^$", title = "^$" },
    no_blur = true,
})

hl.window_rule({ match = { workspace = "w[tv1]s[false]" }, border_size = 0 })

hl.window_rule({ match = { workspace = "m[DP-5]" }, scrolling_width = 0.5 })
hl.window_rule({ match = { workspace = "m[HDMI-A-2]" }, scrolling_width = 0.333 })
