hl.layer_rule({
    name = "noctalia",
    match = { namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd)$" },
    blur = true,
    blur_popups = true,

    ignore_alpha = 0.2,
})
hl.layer_rule({ match = { namespace = "^(selection)$" }, no_anim = true })

hl.layer_rule({
    match = { namespace = "^(voxtype-osd)$" },
    blur = true,
    ignore_alpha = 0.4,
    no_anim = true,
})

hl.layer_rule({
    match = { namespace = "^(vicinae)$" },
    blur = true,
    ignore_alpha = 0.5,
})
