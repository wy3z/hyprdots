local M = {}

local function recording()
    local p = io.popen("ps -eo args=")
    if not p then
        return false
    end
    for line in p:lines() do
        if line:find("screen-toolkit-record-", 1, true) then
            p:close()
            return true
        end
    end
    p:close()
    return false
end

function M.toggle()
    if recording() then
        hl.exec_cmd("noctalia msg plugin alexander/screen-toolkit:service all recordStop")
    else
        hl.exec_cmd("noctalia msg plugin alexander/screen-toolkit:service all toggle")
    end
end

return M
