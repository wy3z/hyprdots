-- Class patterns must be whole-string. Do not zero GNOME border_size (CSD hairline).
hl.window_rule({ match = { class = "^(org\\.gnome\\.Calculator)$" }, float = true })
hl.window_rule({ match = { class = "^(zoom)$" }, float = true })

hl.window_rule({
    match  = { class = "(?i)^(xdg-desktop-portal-gtk)$" },
    float  = true,
    size   = { "((monitor_h>monitor_w) ? monitor_w*0.85 : monitor_w*0.5)", "(monitor_h*0.55)" },
    center = true,
    no_blur     = true,
    no_shadow   = true,
    border_size = 0,
})

-- Helium PWAs auto-float via WM_WINDOW_ROLE=pop-up; Bitwarden re-floats on its own class.
hl.window_rule({
    match = { class = "(?i)^(helium)$" },
    float = false,
})
-- Chromium appends the URL path to PWA classes.
hl.window_rule({
    match       = { class = "^chrome-nngceckbapebfimnlniiiahkandclblb.*$" },
    float       = true,
    border_size = 0,
})
hl.window_rule({
    match           = { class = "^com\\.freerdp\\.client\\.sdl3$" },
    float           = false,
    scrolling_width = 1.0,
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

hl.window_rule({ match = { class = "^discord$", float = true }, center = true })

hl.window_rule({ match = { float = true }, animation = "popin 80%" })

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

hl.window_rule({
    match = { xwayland = true, float = true, class = "^$", title = "^$" },
    no_blur = true,
})

hl.window_rule({ match = { workspace = "m[DP-2]" }, scrolling_width = 0.5 })
hl.window_rule({ match = { workspace = "m[HDMI-A-1]" }, scrolling_width = 0.333 })
