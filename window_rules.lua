-- =====================================================================
-- Window rules
-- =====================================================================
hl.window_rule({ match = { class = "^(org\\.gnome\\.)" }, border_size = 0 })
hl.window_rule({ match = { class = "^(org\\.quickshell)$" }, float = true })
hl.window_rule({ match = { class = "^(org\\.gnome\\.Calculator)$" }, float = true })
hl.window_rule({ match = { class = "^(org\\.gnome\\.Nautilus)$" }, float = true })
hl.window_rule({ match = { class = "^(zoom)$" }, float = true })
hl.window_rule({ match = { float = false }, no_shadow = false })
hl.window_rule({
    match  = { class = "^(xdg-desktop-portal-gtk)$" },
    float  = true,
    size   = { "(monitor_w*0.5)", "(monitor_h*0.55)" },
    center = true,
})
hl.window_rule({ match = { class = "^(chrome-nngceckbapebfimnlniiiahkandclblb-Default)$" }, float = true, border_size = 0 })
hl.window_rule({
    match       = { class = "^(com\\.gabm\\.satty)$" },
    float       = true,
    border_size = 0,
    center      = true,
})
hl.window_rule({ match = { float = true }, animation = "popin 80%" })
hl.window_rule({ match = { workspace = "w[tv1]s[false]" }, border_size = 0 })

-- Per-monitor starting column width for NEW windows on the scrolling layout
hl.window_rule({ match = { workspace = "m[DP-5]" }, scrolling_width = 0.5 })
hl.window_rule({ match = { workspace = "m[HDMI-A-2]" }, scrolling_width = 0.333 })
