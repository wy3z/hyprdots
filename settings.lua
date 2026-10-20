local config = {
    cursor = {
        no_warps = true,
    },
    general = {
        border_size = 1,
        resize_on_border = false,
        gaps_in = 3,
        gaps_out = 6,
        col = {

            active_border = "rgb(606060)",
            inactive_border = "rgb(303030)",
        },
        layout = "dwindle",
        snap = { enabled = false },
    },
    binds = {
        drag_threshold = 10,
        scroll_event_delay = 0,
    },
    dwindle = {
        force_split                  = 2,
        preserve_split               = true,
        smart_split                  = false,
        smart_resizing               = true,
        permanent_direction_override = false,
        special_scale_factor         = 1,
        split_width_multiplier       = 1.0,
        use_active_for_splits        = true,
        default_split_ratio          = 1.0,
        split_bias                   = 0,
        precise_mouse_move           = false,
    },
    decoration = {
        rounding = 6,
        border_part_of_window = false,
        blur = {
            enabled = true,
            size = 3,
            passes = 3,
            brightness = 0.9,
            contrast = 0.96,
            vibrancy = 0.25,
            vibrancy_darkness = 0.1,
            noise = 0.025,
            ignore_opacity = true,
            new_optimizations = true,
        },
        shadow = {
            enabled = true,
            range = 70,
            render_power = 2,
            offset = { 0, 18 },
            color = "rgba(00000066)",
            color_inactive = "rgba(00000040)",
        },
    },
    animations = {
        enabled = true,
    },
    input = {
        kb_layout = "us",
        repeat_rate = 25,
        repeat_delay = 600,
        numlock_by_default = true,
        follow_mouse = 0,
        sensitivity = -0.3,
        accel_profile = "adaptive",
        natural_scroll = false,
        left_handed = false,
        touchpad = {
            natural_scroll = true,
            tap_to_click = true,
            tap_and_drag = true,
            drag_lock = true,
            disable_while_typing = true,
            middle_button_emulation = false,
        },
    },
    misc = {
        focus_on_activate = true,
        vrr = 0,
        background_color = "rgb(000000)",
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        force_default_wallpaper = 0,
        middle_click_paste = false,
    },
}

hl.config(config)

local gap = config.general.gaps_out
hl.workspace_rule({
    workspace = "m[DP-2]",
    gaps_out = { top = gap - 4, right = gap, bottom = gap, left = gap },
})
