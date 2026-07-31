-- =====================================================================
-- LAYOUTS
-- Per-workspace layouts.
-- =====================================================================
for ws = 1, 10 do
    hl.workspace_rule({
        workspace = tostring(ws),
        layout = "scrolling",
        layout_opts = { direction = "right" }
    })
end

for ws = 11, 20 do
    hl.workspace_rule({
        workspace = tostring(ws),
        layout = "scrolling",
        layout_opts = { direction = "down" }
    })
end

hl.config({
    scrolling = {
        -- Global fallback width for columns the window rules can't reach (they
        -- only fire at map time) -- see act.default_col_width for the
        -- per-direction defaults.
        column_width = 0.333,
        -- explicit_column_widths (the +conf/-conf preset ring) is deliberately
        -- unset: nothing cycles presets any more, and `colresize <float>`
        -- accepts any fraction whether or not it's in that list -- SUPER+R /
        -- SUPER+SHIFT+R pass explicit fractions via act.col_toggle.
        wrap_focus = false,
        fullscreen_on_one_column = false,
    },
})
