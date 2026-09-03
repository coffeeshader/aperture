require("theme")

hl.on("hyprland.start", function()
    hl.exec_cmd("uwsm finalize")
end)


------------------
---- MONITORS ----
------------------

hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})

hl.monitor({
    output              = "DP-1",
    mode                = "preferred",
    position            = "0x0",
    scale               = 4 / 3,
    bitdepth            = 10,
    vrr                 = 2,
    cm                  = "hdredid",
    supports_hdr        = 1,
    supports_wide_color = 1,
    max_luminance       = 560,
    sdr_max_luminance   = 250,
    sdr_min_luminance   = 0,
    sdrsaturation       = 0.95,
})


---------------------
---- MY PROGRAMS ----
---------------------

local terminal = "ghostty"
local editor   = "emacsclient -c"
local browser  = "helium"
local music    = "ghostty -e rmpc"
local menu     = "fuzzel"


-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in  = 8,
        gaps_out = 16,

        border_size = 3,

        col = {
            active_border   = { colors = { "rgba(" .. theme.accent .. "ee)", "rgba(" .. theme.lavender .. "ee)" }, angle = 45 },
            inactive_border = "rgba(" .. theme.surface1 .. "aa)",
        },

        resize_on_border = false,

        allow_tearing = false,

        layout = "scrolling",
    },

    decoration = {
        rounding       = 10,
        rounding_power = 2,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        blur = {
            enabled   = true,
            size      = 3,
            passes    = 1,
            vibrancy  = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})

hl.curve("quick",       { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })
hl.curve("easeOutExpo", { type = "bezier", points = { {0.16, 1},    {0.3, 1}     } })
hl.curve("easeOutQuad", { type = "bezier", points = { {0.25, 0.46}, {0.45, 0.94} } })

hl.curve("niriMove",      { type = "spring", mass = 1, stiffness = 800,  dampening = 56.57 })
hl.curve("niriWorkspace", { type = "spring", mass = 1, stiffness = 1000, dampening = 63.25 })

hl.animation({ leaf = "global",     enabled = true,  speed = 10,  bezier = "default" })
hl.animation({ leaf = "border",     enabled = false })
hl.animation({ leaf = "windows",    enabled = true,  speed = 3,   spring = "niriMove" })
hl.animation({ leaf = "windowsIn",  enabled = true,  speed = 1.5, bezier = "easeOutExpo" })
hl.animation({ leaf = "windowsOut", enabled = true,  speed = 1.5, bezier = "easeOutQuad" })
hl.animation({ leaf = "fadeIn",     enabled = true,  speed = 1.5, bezier = "easeOutExpo" })
hl.animation({ leaf = "fadeOut",    enabled = true,  speed = 1.5, bezier = "easeOutQuad" })
hl.animation({ leaf = "fade",       enabled = true,  speed = 1.5, bezier = "easeOutQuad" })
hl.animation({ leaf = "layers",     enabled = false })
hl.animation({ leaf = "workspaces", enabled = true,  speed = 2,   spring = "niriWorkspace", style = "slidevert" })
hl.animation({ leaf = "zoomFactor", enabled = true,  speed = 7,   bezier = "quick" })

hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
        column_width = 0.5,
    },
})


----------------
----  MISC  ----
----------------

hl.config({
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
        disable_splash_rendering = true,
    },

    ecosystem = {
        no_update_news = true,
    },

    render = {
        cm_sdr_eotf = "gamma22force",
    },

    debug = {
        full_cm_proto = true,
    },
})


---------------
---- INPUT ----
---------------

hl.config({
    xwayland = {
        force_zero_scaling = true,
    },
})

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        numlock_by_default = true,

        follow_mouse = 1,

        sensitivity = 0,

        touchpad = {
            natural_scroll = true,
        },
    },

    cursor = {
        inactive_timeout = 3,
        hide_on_key_press = true,
    },
})

hl.device({
    name          = "razer-razer-viper-v3-pro",
    sensitivity   = -0.2,
    accel_profile = "flat",
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

local function focusVertical(dir)
    local active = hl.get_active_window()
    if active then
        local ax, ay = active.at.x, active.at.y
        local aw, ah = active.size.x, active.size.y
        local best = nil
        for _, w in ipairs(hl.get_workspace_windows(active.workspace)) do
            if w.address ~= active.address and w.mapped and not w.hidden then
                local gx, gy = w.at.x, w.at.y
                local gw, gh = w.size.x, w.size.y
                if gx < ax + aw and gx + gw > ax then
                    local candidate = dir > 0 and gy >= ay + ah or dir < 0 and gy + gh <= ay
                    if candidate and (not best or (dir > 0 and gy < best.y) or (dir < 0 and gy > best.y)) then
                        best = { win = w, y = gy }
                    end
                end
            end
        end
        if best then
            hl.dispatch(hl.dsp.focus({ window = best.win }))
            return
        end
    end
    hl.dispatch(hl.dsp.focus({ workspace = dir > 0 and "+1" or "-1" }))
end

hl.bind(mainMod .. " + Return",     hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Space",      hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + E",          hl.dsp.exec_cmd(editor))
hl.bind(mainMod .. " + B",          hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + M",          hl.dsp.exec_cmd(music))
hl.bind(mainMod .. " + SHIFT + M",  hl.dsp.exec_cmd("rmpc togglepause"))
hl.bind(mainMod .. " + semicolon",  hl.dsp.exec_cmd("rmpc volume -5"))
hl.bind(mainMod .. " + apostrophe", hl.dsp.exec_cmd("rmpc volume +5"))

hl.bind(mainMod .. " + Q",             hl.dsp.window.close())
hl.bind("ALT + F4",                    hl.dsp.window.close())
hl.bind(mainMod .. " + CTRL + Escape", hl.dsp.window.kill())
hl.bind(mainMod .. " + SHIFT + F",     hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + V",             hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + X",             hl.dsp.group.toggle())

hl.bind(mainMod .. " + left",  hl.dsp.layout("focus l"))
hl.bind(mainMod .. " + H",     hl.dsp.layout("focus l"))
hl.bind(mainMod .. " + right", hl.dsp.layout("focus r"))
hl.bind(mainMod .. " + L",     hl.dsp.layout("focus r"))
hl.bind(mainMod .. " + up",    hl.dsp.layout("focus u"))
hl.bind(mainMod .. " + K",     function() focusVertical(-1) end)
hl.bind(mainMod .. " + down",  hl.dsp.layout("focus d"))
hl.bind(mainMod .. " + J",     function() focusVertical(1) end)

hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.layout("swapcol l"))
hl.bind(mainMod .. " + SHIFT + H",     hl.dsp.layout("swapcol l"))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.layout("swapcol r"))
hl.bind(mainMod .. " + SHIFT + L",     hl.dsp.layout("swapcol r"))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + K",     hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "d" }))
hl.bind(mainMod .. " + SHIFT + J",     hl.dsp.window.move({ direction = "d" }))

hl.bind(mainMod .. " + bracketleft",  hl.dsp.layout("consume_or_expel prev"))
hl.bind(mainMod .. " + bracketright", hl.dsp.layout("consume_or_expel next"))

hl.bind(mainMod .. " + F",        hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mainMod .. " + minus",    hl.dsp.layout("colresize -0.1"))
hl.bind(mainMod .. " + equal",    hl.dsp.layout("colresize +0.1"))
hl.bind(mainMod .. " + CTRL + C", hl.dsp.layout("center"))
hl.bind(mainMod .. " + CTRL + X", hl.dsp.layout("fit visible"))

hl.bind("ALT + Tab", function()
    hl.dispatch(hl.dsp.window.cycle_next())
    hl.dispatch(hl.dsp.window.bring_to_top())
end)

for i = 1, 9 do
    hl.bind(mainMod .. " + " .. i,          hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + CTRL + " .. i,   hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + U",                hl.dsp.focus({ workspace = "+1" }))
hl.bind(mainMod .. " + Page_Down",        hl.dsp.focus({ workspace = "+1" }))
hl.bind(mainMod .. " + I",                hl.dsp.focus({ workspace = "-1" }))
hl.bind(mainMod .. " + Page_Up",          hl.dsp.focus({ workspace = "-1" }))
hl.bind(mainMod .. " + CTRL + U",         hl.dsp.window.move({ workspace = "+1", follow = true }))
hl.bind(mainMod .. " + CTRL + Page_Down", hl.dsp.window.move({ workspace = "+1", follow = true }))
hl.bind(mainMod .. " + CTRL + I",         hl.dsp.window.move({ workspace = "-1", follow = true }))
hl.bind(mainMod .. " + CTRL + Page_Up",   hl.dsp.window.move({ workspace = "-1", follow = true }))

hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})
