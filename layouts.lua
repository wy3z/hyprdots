-- =====================================================================
-- LAYOUTS
-- Per-workspace layouts.
-- =====================================================================
for ws = 11, 20 do
    hl.workspace_rule({
        workspace = tostring(ws),
        layout = "scrolling",
        layout_opts = { direction = "down" }
    })
end

hl.config({
    scrolling = {
        column_width = 0.333,
        explicit_column_widths = "0.333, 0.5, 1.0",
        wrap_focus = false,
        fullscreen_on_one_column = false,
    },
})
