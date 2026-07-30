-- =====================================================================
-- Startup
-- =====================================================================

hl.on("hyprland.start", function()
    -- Import the Wayland/Hyprland env into the systemd & D-Bus user managers
    -- BEFORE starting the session target. The target activates
    -- xdg-desktop-portal-hyprland, which segfaults with "Couldn't connect to a
    -- wayland compositor" (and then hits its restart limit, killing screen
    -- capture for the whole session) if WAYLAND_DISPLAY /
    -- HYPRLAND_INSTANCE_SIGNATURE aren't in its environment yet. Both steps must
    -- run in one command so the import is guaranteed to finish first.
    hl.exec_cmd(
    "dbus-update-activation-environment --systemd WAYLAND_DISPLAY HYPRLAND_INSTANCE_SIGNATURE XDG_CURRENT_DESKTOP && systemctl --user start hyprland-session.target")
    hl.exec_cmd("noctalia")
    hl.exec_cmd("/usr/lib/pam_kwallet_init")
    hl.exec_cmd("vicinae server")
    hl.exec_cmd("kwalletd6")
    hl.exec_cmd("wl-paste --type text  --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("sleep 1 && hyprctl dispatch focusmonitor DP-5")
    hl.exec_cmd("hyprpm reload")
    -- Not hyprpm-managed (its hyprpm.toml has no commit pin for this Hyprland
    -- branch yet), so load the manually-built .so directly. See
    -- ~/.local/share/hypr-plugins/hyprland-scroll-overview/PATCH-NOTES.md.
    hl.exec_cmd("hyprctl plugin load ~/.local/share/hypr-plugins/hyprland-scroll-overview/scrolloverview.so")
end)
