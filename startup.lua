hl.on("hyprland.start", function()
    hl.exec_cmd(
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY HYPRLAND_INSTANCE_SIGNATURE XDG_CURRENT_DESKTOP && systemctl --user start hyprland-session.target"
    )
    hl.exec_cmd("/home/wyez/.local/bin/noctalia")
    hl.exec_cmd("ghostty --gtk-single-instance=true --quit-after-last-window-closed=false --initial-window=false")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("sleep 1 && hyprctl dispatch focusmonitor 'desc:Dell Inc. DELL S2721DGF 3QWBP83'")
    hl.exec_cmd("hyprpm reload")
end)
