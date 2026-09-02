-- ~/.config/hypr/hyprconfigs/windowrules.lua
-- Hyprland 0.55+ Lua config
-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/

-------------------
---- WOFI ---------
-------------------
hl.window_rule({
    name      = "windowrule-wofi-1",
    match     = { class = "^(wofi)$" },
    animation = "slide",            -- animation style as a string
    no_shadow = true,               -- disables shadow for the wofi window
})

hl.window_rule({
    name        = "windowrule-wofi-2",
    match       = { class = "^(wofi)" },
    border_size = 0,                -- removes the window border for wofi
})

hl.window_rule({
    name  = "windowrule-wofi-3",
    match = { class = "^(wofi)$", title = "^(clippick)$" },
    move  = "1315 70",              -- move is a string
})

-------------------
---- BROWSERS -----
-------------------
hl.window_rule({
    name    = "windowrule-netflix",
    match   = { class = "^(netflix)$" },
    opacity = "1.0 override",       -- absolute opacity value as a string
    no_dim  = true,                 -- prevents the window from dimming
})

-------------------
---- CHROMIUM -----
-------------------
hl.window_rule({
    name  = "windowrule-chromium-twitch",
    match = { class = "^(Chromium)$", initial_title = "^(twitch.tv_/)$" },
    tile  = true,                   -- forces the window to be tiled
})

hl.window_rule({
    name  = "windowrule-chromium-whatsapp",
    match = { class = "^(Chromium)$", initial_title = "^(web.whatsapp.com_/)$" },
    tile  = true,
})

-------------------
---- MISC APPS ----
-------------------
hl.window_rule({
    name  = "windowrule-godot",
    match = { initial_title = "^(Godot)$" },
    tile  = true,
})

hl.window_rule({
    name  = "windowrule-waypaper",
    match = { class = "^(waypaper)$" },
    float = true,                   -- makes the window float
})

hl.window_rule({
    name  = "windowrule-aseprite",
    match = { class = "^(aseprite.exe)$" },
    tile  = true,
})

hl.window_rule({
    name  = "windowrule-picture-in-picture",
    match = { class = "^(firefox)$", initial_title = "^(Picture-in-Picture)$" },
    opacity = "1.0 override",
    no_blur = true,
    no_dim = true
})


-------------------
---- MPV ----------
-------------------
hl.window_rule({
    name    = "windowrule-mpv",
    match   = { class = "^(mpv)$" },
    opacity = "1.0 override",       -- absolute opacity for mpv
    no_blur = true,                 -- disables blur effect
    no_dim  = true,
})

-------------------
---- ZATHURA ------
-------------------
hl.window_rule({
    name    = "windowrule-zathura",
    match   = { class = "^(org.pwmt.zathura)$" },
    no_blur = true,
    no_dim  = false,
    opacity = "1.0 override",       -- absolute opacity for zathura
})

-------------------
---- KITTY --------
-------------------
hl.window_rule({
    name      = "windowrule-kitty",
    match     = { class = "^(kitty)$" },
    no_shadow = false,
    no_blur   = true,
    no_dim    = false,
    opacity   = "1.0 override",     -- absolute opacity for kitty
})

-----------------------
---- XDG PORTAL -------
-----------------------
hl.window_rule({
    name    = "windowrule-xdg-1",
    match   = { class = "Xdg-desktop-portal-gtk", title = "Open Folder" },
    no_blur = true,                 -- disables blur for XDG portal dialogs
})

hl.window_rule({
    name    = "windowrule-xdg-2",
    match   = { class = "^(Xdg-desktop-portal-gtk)$", title = "^(Open Folder)$" },
    opacity = "1.0 override",       -- sets absolute opacity for XDG portal dialogs
})

hl.window_rule({
    name  = "windowrule-thunar-progress",
    match = { class = "^(thunar)", title = "^(File Operation Progress)" },
    float = true,                   -- makes the progress window float
})

-----------------------
---- SYSTEM / OTHER ---
-----------------------
hl.window_rule({
    name    = "windowrule-other",
    -- match = { class = "^()$", title = "^()$" },  -- empty pattern is omitted
    no_blur = true,
    opacity = "1.0 override",
})

hl.window_rule({
    name    = "windowrule-steam",
    match   = { class = "^(steam)$" },
    opacity = "1.0 override",
})

hl.window_rule({
    name   = "windowrule-feh",
    match  = { class = "^(feh)$" },
    no_dim = true,                  -- prevents dimming for feh
})

hl.window_rule({
    name    = "windowrule-crx",
    match   = { initial_title = "^(_crx_kmfikkopdhmbdbkndkamabamlkkgkpod)$" },
    no_dim  = true,
    no_blur = true,
    opacity = "1.0 override",
})

--------------
---- GLAVA ---
--------------

hl.window_rule({
    name="background-glava",
    match={ class = "^(GLava)$"},
    no_dim = false,
    no_blur = false,
    float = true,
    size = {1920, 1080},
    no_focus = true,
    pin = true,
    opacity = "1.0 override 0.5 override",

})




hl.window_rule({
    name = "whatsapp_silent",
    match = {
        class = "^chrome-web\\.whatsapp\\.com__-Default$",
    },
    workspace = "special:network_social silent",
})