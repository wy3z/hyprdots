hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
-- Modern Electron and other toolkits use this for native Wayland detection.
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XCURSOR_THEME", "wyezMoj")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("GDK_WAYLAND_DISABLE", "ext_background_effect_manager_v1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
hl.env("FREETYPE_PROPERTIES", "cff:no-stem-darkening=1 autofitter:no-stem-darkening=1 type1:no-stem-darkening=1 t1cid:no-stem-darkening=1")
