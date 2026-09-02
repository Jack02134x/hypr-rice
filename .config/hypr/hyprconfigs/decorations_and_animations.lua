-- ~/.config/hypr/hyprconfigs/decorations_and_animations.lua
-- Hyprland 0.55+ Lua config

-- Colors come from the matugen-generated module
local c = require("matugen/matugen-hyprland")


hl.config({
    decoration = {
        rounding           = 6,
        active_opacity     = 0.9,
        inactive_opacity   = 0.8,
        fullscreen_opacity = 1.0,
        dim_inactive       = true,
        dim_strength       = 0.3,

        blur = {
            enabled           = false,
            size              = 3,
            passes            = 3,
            new_optimizations = true,
            xray              = true,
            ignore_opacity    = false,
        },

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = c.secondary_fixed_dim,
        },
    },

})

---------------------------
---- BEZIER CURVES --------
---------------------------

hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("easeInOutCirc",  { type = "bezier", points = { {0.85, 0},    {0.15, 1}    } })
hl.curve("easeOutCirc",    { type = "bezier", points = { {0, 0.55},    {0.45, 1}    } })
hl.curve("easeOutExpo",    { type = "bezier", points = { {0.16, 1},    {0.3, 1}     } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1.0}  } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })
hl.curve("shot",           { type = "bezier", points = { {0.2, 1.0},   {0.2, 1.0}   } })
hl.curve("swipe",          { type = "bezier", points = { {0.6, 0.0},   {0.2, 1.05}  } })
hl.curve("progressive",    { type = "bezier", points = { {1.0, 0.0},   {0.6, 1.0}   } })
hl.curve("md3_standard",   { type = "bezier", points = { {0.2, 0},     {0, 1}       } })
hl.curve("md3_decel",      { type = "bezier", points = { {0.05, 0.7},  {0.1, 1}     } })
hl.curve("md3_accel",      { type = "bezier", points = { {0.3, 0},     {0.8, 0.15}  } })
hl.curve("overshot",       { type = "bezier", points = { {0.05, 0.9},  {0.1, 1.1}   } })
hl.curve("crazyshot",      { type = "bezier", points = { {0.1, 1.5},   {0.76, 0.92} } })
hl.curve("hyprnostretch",  { type = "bezier", points = { {0.05, 0.9},  {0.1, 1.0}   } })
hl.curve("fluent_decel",   { type = "bezier", points = { {0.1, 1},     {0, 1}       } })

---------------------------
---- ANIMATIONS -----------
---------------------------

hl.animation({ leaf = "windows",          enabled = true, speed = 3,   bezier = "md3_standard", style = "popin 60%" })
hl.animation({ leaf = "border",           enabled = true, speed = 10,  bezier = "default" })
hl.animation({ leaf = "fade",             enabled = true, speed = 2.5, bezier = "md3_decel" })
hl.animation({ leaf = "workspaces",       enabled = true, speed = 3.5, bezier = "overshot",   style = "slide" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 3,   bezier = "md3_decel",  style = "slidevert" })