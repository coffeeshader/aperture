hl.monitor({
    output   = "eDP-2",
    mode     = "2560x1600@165",
    position = "0x0",
    scale    = 1.6,
    vrr      = 1,
})

hwCursors = true

hl.config({
    render = {
        direct_scanout = 1,
    },
})
