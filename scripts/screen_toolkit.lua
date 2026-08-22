local M = {}

local function exec(cmd)
    hl.dispatch(hl.dsp.exec_cmd(cmd))
end

-- Recorders (gpu-screen-recorder / wf-recorder / wl-screenrec) put
-- /tmp/screen-toolkit-record-<ts>.mp4 on their argv. The file may not
-- exist until stop, so don't look at the filesystem.
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
        exec("noctalia msg plugin alexander/screen-toolkit:service all recordStop")
    else
        exec("noctalia msg plugin alexander/screen-toolkit:service all toggle")
    end
end

return M
