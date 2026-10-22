local policy = require("scripts.monitor_policy")

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

hl.window_rule({
    match = { class = "(?i)^(helium)$" },
    float = false,
})

hl.window_rule({
    match = {
        class = "^chrome-outlook\\.cloud\\.microsoft_.*$",
        initial_title = "^about:blank$",
    },
    float = true,
    size = { 1300, 900 },
    center = true,
    pin = true,
})

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

hl.window_rule({
    match = { class = "(?i)^slack$", initial_title = "(?i)^huddle(:.*)?$" },
    float = true,
    size = { 960, 540 },
    center = true,
})

hl.window_rule({
    match    = { title = "(?i)^picture-in-picture$" },
    float    = true,
    pin      = true,
    center   = true,
    decorate = false,
})


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

hl.window_rule({
    match = { modal = true },
    float = true,
    center = true,
})

for _, monitor in ipairs(policy.monitor_order) do
    hl.window_rule({
        match = { workspace = "m[" .. monitor .. "]" },
        scrolling_width = policy.monitor_widths[monitor],
    })
end
