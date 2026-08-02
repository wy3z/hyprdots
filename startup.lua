hl.on("hyprland.start", function()
    -- Import Wayland variables before starting portal services.
    hl.exec_cmd(
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY HYPRLAND_INSTANCE_SIGNATURE XDG_CURRENT_DESKTOP && systemctl --user start hyprland-session.target"
    )
    hl.exec_cmd("noctalia")
    hl.exec_cmd("/usr/lib/pam_kwallet_init")
    hl.exec_cmd("vicinae server")
    hl.exec_cmd("kwalletd6")
    hl.exec_cmd("mullvad-vpn")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("sleep 1 && hyprctl dispatch focusmonitor DP-5")
    hl.exec_cmd("hyprpm reload")
end)
