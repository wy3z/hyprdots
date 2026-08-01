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
        -- Portrait monitor: display as 1-10 instead of 11-20.
        default_name = tostring(ws - 10),
        layout = "scrolling",
        layout_opts = { direction = "down" }
    })
end

hl.config({
    scrolling = {
        -- Fallback for columns created after window rules run.
        column_width = 0.333,
        wrap_focus = false,
        fullscreen_on_one_column = false,
    },
})
