local policy = require("scripts.monitor_policy")
local directions = {}

local function apply_directions(reset)
    local current_layouts = {}
    for _, workspace in ipairs(hl.get_workspaces()) do
        current_layouts[workspace.id] = workspace.tiled_layout
    end

    for _, monitor in ipairs(hl.get_monitors()) do
        local base = policy.monitor_workspace_base(monitor)
        if base then
            local direction = policy.is_portrait(monitor) and "down" or "right"
            local previous = directions[base]
            if previous ~= direction then
                directions[base] = direction
                local default = direction == "down" and "scrolling" or "dwindle"
                for i = 1, policy.workspaces_per_monitor do
                    -- Keep toggled layouts across reloads, but reset them when orientation changes.
                    hl.workspace_rule({
                        workspace = tostring(base + i),
                        layout = not reset and previous == nil and current_layouts[base + i] or default,
                        layout_opts = { direction = direction },
                        animation = direction == "down" and "slide" or "slidevert",
                    })
                end
            end
        end
    end
end

local ZWSP = string.char(0xE2, 0x80, 0x8B)
for ws = 1, #policy.monitor_order * policy.workspaces_per_monitor do
    hl.workspace_rule({
        workspace = tostring(ws),
        default_name = ws > policy.workspaces_per_monitor
            and tostring(ws - policy.workspaces_per_monitor) .. ZWSP or nil,
    })
end

apply_directions()

hl.on("hyprland.start", function()
    directions = {}
    apply_directions(true)
end)
local function sync_directions() apply_directions() end
hl.on("workspace.active", sync_directions)
for _, event in ipairs({ "monitor.added", "monitor.removed", "monitor.layout_changed" }) do
    hl.on(event, sync_directions)
end

hl.config({
    scrolling = {
        column_width = policy.portrait_width,
        wrap_focus = false,
        fullscreen_on_one_column = false,
    },
})
