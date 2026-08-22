local M = {}

local sounds = os.getenv("HOME") .. "/.config/voxtype/sounds"

local function state_path()
    local runtime = os.getenv("XDG_RUNTIME_DIR")
    if not runtime or runtime == "" then
        runtime = "/run/user/" .. (os.getenv("UID") or "1000")
    end
    return runtime .. "/voxtype/state"
end

local function read_state()
    local f = io.open(state_path(), "r")
    if not f then
        return "idle"
    end
    local line = f:read("*l") or "idle"
    f:close()
    return (line:gsub("%s+$", ""))
end

function M.toggle()
    local state = read_state()
    local clip
    if state == "streaming" or state == "recording" then
        clip = sounds .. "/stop-ocean.wav"
    else
        clip = sounds .. "/start-ocean.wav"
    end
    -- Background: don't wait for the clip before toggling capture.
    os.execute("pw-play --volume 0.4 " .. string.format("%q", clip) .. " >/dev/null 2>&1 &")
    hl.dispatch(hl.dsp.exec_cmd("voxtype record toggle"))
end

return M
