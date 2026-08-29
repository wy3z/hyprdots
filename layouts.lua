
local function block_base(monitor)
    local ws = monitor.active_workspace
    if not ws or not ws.id then return nil end
    if ws.id >= 1 and ws.id <= 10 then return 0 end
    if ws.id >= 11 and ws.id <= 20 then return 10 end
    return nil
end

local function apply_directions()
    for _, monitor in ipairs(hl.get_monitors()) do
        local base = block_base(monitor)
        if base then
            local width, height = monitor.width, monitor.height
            if monitor.transform % 2 == 1 then width, height = height, width end
            local direction = height > width and "down" or "right"
            for i = 1, 10 do
                hl.workspace_rule({
                    workspace = tostring(base + i),
                    layout = "scrolling",
                    layout_opts = { direction = direction },
                })
            end
        end
    end
end

-- Render 11-20 as 1-10 without duplicating names used by the plugin.
local ZWSP = string.char(0xE2, 0x80, 0x8B)
for ws = 11, 20 do
    hl.workspace_rule({
        workspace = tostring(ws),
        default_name = tostring(ws - 10) .. ZWSP,
    })
end

apply_directions()

hl.on("hyprland.start", apply_directions)
hl.on("workspace.active", apply_directions)
for _, event in ipairs({ "monitor.added", "monitor.removed", "monitor.layout_changed" }) do
    hl.on(event, apply_directions)
end

hl.config({
    scrolling = {

        column_width = 0.333,
        wrap_focus = false,
        fullscreen_on_one_column = false,
    },
})
