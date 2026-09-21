local M = {}

local POP_WIDTH = 1300
local POP_HEIGHT = 900

local was_floating = {}

function M.pop()
    local win = hl.get_active_window()
    if not win then return end

    local target = "address:" .. win.address

    local live = {}
    for _, w in ipairs(hl.get_windows()) do live[w.address] = true end
    for address in pairs(was_floating) do
        if not live[address] then was_floating[address] = nil end
    end

    if win.pinned then
        hl.dispatch(hl.dsp.window.pin({ window = target }))
        if win.floating and not was_floating[win.address] then
            hl.dispatch(hl.dsp.window.float({ window = target, action = "toggle" }))
        end
        was_floating[win.address] = nil
        return
    end

    was_floating[win.address] = win.floating

    if not win.floating then
        hl.dispatch(hl.dsp.window.float({ window = target, action = "toggle" }))
    end

    hl.dispatch(hl.dsp.window.resize({ window = target, x = POP_WIDTH, y = POP_HEIGHT }))
    hl.dispatch(hl.dsp.window.center({ window = target }))
    hl.dispatch(hl.dsp.window.pin({ window = target }))
    hl.dispatch(hl.dsp.window.alter_zorder({ window = target, mode = "top" }))
end

return M
