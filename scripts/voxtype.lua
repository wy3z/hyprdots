local M = {}

local sounds = os.getenv("HOME") .. "/.local/share/sounds/bigsur/stereo"

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

local function monotonic_time()
    local f = io.open("/proc/uptime", "r")
    if not f then
        return 0
    end
    local value = tonumber(f:read("*n")) or 0
    f:close()
    return value
end

local function play(name)
    local filename = name == "start" and "power-plug.oga" or "power-unplug.oga"
    local clip = sounds .. "/" .. filename
    os.execute("pw-play --volume 1.0 " .. string.format("%q", clip) .. " >/dev/null 2>&1 &")
end

-- F14 remapping/firmware produces a roughly 450ms ordinary press, so leave
-- enough headroom for a tap to toggle while retaining deliberate hold-to-talk.
local HOLD_THRESHOLD = 0.75
local RELEASE_SETTLE_SECONDS = 0.05
local pressed_at = nil
local stop_on_release = false

local function stop_after_release(delay)
    play("stop")
    delay = delay or RELEASE_SETTLE_SECONDS
    if delay <= 0 then
        hl.dispatch(hl.dsp.exec_cmd("voxtype record stop"))
        return
    end
    -- Keyboard chords need time for Super to clear; modifier-free mouse input
    -- can stop immediately.
    local command = string.format("sh -c 'sleep %.2f; voxtype record stop'", delay)
    hl.dispatch(hl.dsp.exec_cmd(command))
end

-- Hybrid behavior: press starts recording. A second tap is marked to stop on
-- release; otherwise release stops only after a deliberate hold.
function M.press()
    local state = read_state()
    if state == "streaming" or state == "recording" then
        stop_on_release = true
        pressed_at = nil
        return
    end

    stop_on_release = false
    pressed_at = monotonic_time()
    play("start")
    hl.dispatch(hl.dsp.exec_cmd("voxtype record start"))
end

local function release(delay)
    if stop_on_release then
        stop_on_release = false
        stop_after_release(delay)
        return
    end
    if not pressed_at then
        return
    end

    local held_for = monotonic_time() - pressed_at
    pressed_at = nil
    if held_for >= HOLD_THRESHOLD then
        stop_after_release(delay)
    end
end

function M.release()
    release(RELEASE_SETTLE_SECONDS)
end

function M.direct_release()
    -- Dedicated keys such as Scroll Lock have no modifier to settle.
    release(0)
end

return M
