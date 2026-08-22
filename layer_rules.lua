-- Noctalia
hl.layer_rule({
    name = "noctalia",
    match = { namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd)$" },
    blur = true,
    blur_popups = true,
    -- Below the bar's ~0.28 opacity, but above transparent padding.
    ignore_alpha = 0.4,
})
hl.layer_rule({ match = { namespace = "^(selection)$" }, no_anim = true })

hl.layer_rule({
    match = { namespace = "^(voxtype-osd)$" },
    blur = true,
    ignore_alpha = 0.4,
    no_anim = true,
})

-- Vicinae
hl.layer_rule({
    match = { namespace = "^(vicinae)$" },
    animation = "popin 80%",
    blur = true,
    ignore_alpha = 0.5,
})
