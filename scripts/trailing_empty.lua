-- Keep the first empty workspace in each monitor block alive.
local BLOCK_SIZE = 10
local pinned = {}
local timer

local function block_base(monitor)
    local ws = monitor.active_workspace
    if not ws or not ws.id then return nil end
    if ws.id < 1 or ws.id > 2 * BLOCK_SIZE then return nil end
    return math.floor((ws.id - 1) / BLOCK_SIZE) * BLOCK_SIZE
end

local function wanted_slots()
    local occupied = {}
    for _, ws in ipairs(hl.get_workspaces()) do
        if ws.id and ws.id > 0 and ws.windows and ws.windows > 0 then
            occupied[ws.id] = true
        end
    end

    local wanted = {}
    for _, monitor in ipairs(hl.get_monitors()) do
        local base = block_base(monitor)
        if base then
            local slot
            for i = 1, BLOCK_SIZE do
                local id = base + i
                if not occupied[id] then
                    slot = id
                    break
                end
            end

            -- The active empty workspace already provides a free slot.
            local active = monitor.active_workspace.id
            if slot and (occupied[active] or active == slot) then
                wanted[slot] = monitor.name
            end
        end
    end
    return wanted
end

local function apply()
    local wanted = wanted_slots()

    for id in pairs(pinned) do
        if not wanted[id] then
            hl.workspace_rule({ workspace = tostring(id), persistent = false })
            pinned[id] = nil
        end
    end
    for id, monitor in pairs(wanted) do
        if pinned[id] ~= monitor then
            hl.workspace_rule({ workspace = tostring(id), persistent = true, monitor = monitor })
            pinned[id] = monitor
        end
    end
end

-- Coalesce event bursts.
local function schedule()
    if timer then timer:set_enabled(false) end
    timer = hl.timer(apply, { timeout = 1, type = "oneshot" })
end

for _, event in ipairs({
    "workspace.active",
    "window.open",
    "window.close",
    "window.destroy",
    "window.move_to_workspace",
}) do
    hl.on(event, schedule)
end

-- Monitor remaps clear rules not owned by the plugin.
for _, event in ipairs({ "monitor.added", "monitor.removed", "monitor.layout_changed" }) do
    hl.on(event, function()
        pinned = {}
        schedule()
    end)
end

-- Wait for the plugin to assign workspace blocks.
hl.timer(apply, { timeout = 500, type = "oneshot" })

return true
