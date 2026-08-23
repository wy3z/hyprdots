-- Quake-style pull-down console running pi, adapted from Tobi Lütke's
-- implementation in basecamp/omarchy (default/hypr/qconsole.lua, v4.1).
-- A dimmed overlay drops down over whatever workspace you are on.

local M = {}

-- How much of the usable screen the console covers, measured from the top.
local share = 0.5

-- Spawn pi into the scratchpad console. The exec prefix pins the workspace:
-- Hyprland only tags a spawn with the workspace it came from while
-- misc.initial_workspace_tracking is on. A wrapper script rather than an
-- inline command: Hyprland tokenizes exec rules on whitespace without
-- honouring quotes.
local seed = "[workspace special:scratchpad silent] ghostty -e ~/.config/hypr/scripts/qconsole-agent.sh"

-- Toggle the console, seeding pi whenever it would open empty: first ever
-- open, and every reopen after quitting the agent (an empty hidden special
-- workspace is not destroyed by Hyprland, so a seed-on-open rule alone would
-- only ever fire once).
function M.toggle()
	local occupied = false
	for _, ws in ipairs(hl.get_workspaces() or {}) do
		if (ws.name == "special:scratchpad" or ws.id == -98) and (ws.windows or 0) > 0 then
			occupied = true
			break
		end
	end
	if not occupied then
		hl.dispatch(hl.dsp.exec_cmd(seed))
	end
	hl.dispatch(hl.dsp.workspace.toggle_special("scratchpad"))
end


-- Dimming only applies while a special workspace is open, so the console gets
-- its separation from the workspace underneath without costing anything the
-- rest of the time. Kept at the original 0.6. blur.special = false stops the
-- backdrop underneath being smeared, while the terminal itself still picks up
-- the normal window blur (it shares its class with every other ghostty
-- window -- ghostty 1.3 ignores --class -- so it must NOT opt out here).
hl.config({
	decoration = {
		dim_special = 0.6,
		blur = {
			special = false,
		},
	},
})

-- Keep the pull-down flush with the screen while leaving normal Ghostty
-- windows on regular workspaces unaffected.
hl.window_rule({
	match = { workspace = "special:scratchpad" },
	rounding = 0,
	no_shadow = true,
})

-- Refitting replaces the rule in place rather than stacking a new one, but it
-- still schedules a monitor and window state refresh, and monitor.focused fires
-- on every hop between screens. Most of those hops do not change the number, so
-- only write the rule when it actually moves.
local covering = nil

local function cover(bottom)
	if covering == bottom then
		return
	end
	covering = bottom

	hl.workspace_rule({
		workspace = "special:scratchpad",
		gaps_in = 0,
		gaps_out = { top = 0, right = 0, bottom = bottom, left = 0 },

		-- Nothing to highlight in a console that is only ever focused when it is
		-- open, and the active border reads as a stray frame around a panel that
		-- is already set apart by the dimming behind it.
		no_border = true,
	})
end

-- Sizing the console with a window rule would freeze it at whatever the screen
-- measured when it first opened, because Hyprland resolves those expressions
-- once, as the window maps. Rescaling the monitor afterwards would leave a
-- console that is no longer half of anything. Gaps are re-applied by the layout
-- instead, so the console is sized by the gap left underneath it and that gap
-- is recomputed whenever the monitor layout changes.
local function fit()
	local monitor = hl.get_active_monitor()

	-- A monitor handle whose output has gone away answers nil to every field, and
	-- layout changes are exactly when that happens, so this also covers reading
	-- height and reserved below.
	if not monitor or not monitor.scale or monitor.scale <= 0 then
		return
	end

	-- Monitor dimensions are in physical pixels; gaps are logical, so the scale
	-- has to come out before the reserved area (already logical) comes off.
	local reserved = monitor.reserved
	local usable = monitor.height / monitor.scale - reserved.top - reserved.bottom

	cover(math.max(0, math.floor(usable * (1 - share))))
end

-- Until a monitor can be read, cover the whole work area rather than leaving
-- the console unruled, so it is never seeded without its placement.
cover(0)
fit()

hl.on("monitor.layout_changed", fit)
hl.on("monitor.focused", fit)

-- The direction names the edge the offset is measured from, not where the
-- workspace goes: "slide top" drops it down into view, and "slide bottom"
-- retracts it back up the way a Quake console does. Curves reuse the house
-- springs/beziers defined in animations.lua.
hl.animation({ leaf = "specialWorkspaceIn", enabled = true, speed = 3, bezier = "niriExpo", style = "slide top" })
hl.animation({ leaf = "specialWorkspaceOut", enabled = true, speed = 2, bezier = "niriCubic", style = "slide bottom" })

return M
