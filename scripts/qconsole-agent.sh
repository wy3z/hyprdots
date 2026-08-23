#!/bin/bash
# Launched by qconsole.lua inside the Quake scratchpad terminal.
# Start where agent work happens; fall back to $HOME.
cd "$HOME/Work" 2>/dev/null || cd "$HOME"
export PATH="$HOME/.local/bin:$PATH"
exec "$HOME/.local/bin/pi"
