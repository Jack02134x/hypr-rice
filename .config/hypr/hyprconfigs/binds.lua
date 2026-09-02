-- ~/.config/hypr/hyprconfigs/binds.lua
-- Hyprland 0.55+ Lua config
-- https://wiki.hypr.land/Configuring/Basics/Binds/

local mainMod    = "SUPER"
local term       = "kitty"
local browser    = "firefox"
local screenlock = "hyprlock"
local explorer   = "kitty -e yazi"

hl.config({
    binds = {
        allow_workspace_cycles = true,
    },
})

-------------------------
---- MOUSE BINDS --------
-------------------------
-- mouse:272 = right mouse button (usually)
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e+1" }))

--------------------------
---- TERMINAL / SCRIPTS --
--------------------------
hl.bind(mainMod .. " + Q",         hl.dsp.exec_cmd(term))
hl.bind(mainMod .. " + ALT + M",   hl.dsp.exec_cmd("gcc ~/.scripts/mouseshit/mouse_invert.c -o ~/.local/bin/mouse_invert; pkill mouse_invert; mouse_invert"))
hl.bind(mainMod .. " + ALT + P",   hl.dsp.exec_cmd("pkill wofi; ~/.scripts/screenshot.sh"))
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd("pkill wofi; bash ~/.scripts/quick-settings.sh"))

---------------------------
---- APPLICATION BINDS ----
---------------------------
hl.bind(mainMod .. " + D",         hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + D", hl.dsp.window.close({ force = true }))
hl.bind(mainMod .. " + E",         hl.dsp.exec_cmd("thunar"))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd(explorer))
hl.bind(mainMod .. " + B",         hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("pkill python; pkill mpv; python /home/jack/python-yt-project/play_entire_playlist.py"))
hl.bind(mainMod .. " + ALT + G",         hl.dsp.exec_cmd("pkill glava; kitty -e glava"))
hl.bind(mainMod .. " + SHIFT + G", hl.dsp.exec_cmd("pkill glava"))
hl.bind(mainMod .. " + P",         hl.dsp.exec_cmd("pkill python; pkill mpv"))
hl.bind(mainMod .. " + H",         hl.dsp.exec_cmd("/home/jack/.config/waybar/scripts/Colorpicker.sh"))
hl.bind(mainMod .. " + SHIFT + A", hl.dsp.exec_cmd("cd Videos/anime/; ani-cli -d --rofi"))
hl.bind(mainMod .. " + A",         hl.dsp.exec_cmd("ani-cli --rofi"))

-- Launcher / clipboard / notifications
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("qs ipc call launcher toggle"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("pkill wofi; cliphist list | wofi --dmenu -p clippick -l top_right -x -15 -y 10 -n | cliphist decode | wl-copy"))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("swaync-client -t -sw"))

-- Waybar switcher / wallpaper
hl.bind(mainMod .. " + W",         hl.dsp.exec_cmd("pkill wofi; ~/.config/waybar/waybar-switcher/Menu.sh"))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("pkill wofi; ~/.config/waybar/waybar-switcher/current.sh"))
hl.bind(mainMod .. " + ALT + W",   hl.dsp.exec_cmd("pkill fzf; kitty -e ~/.scripts/wallpaperchanger.sh"))

-- Logout / lock
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("pkill wlogout; wlogout"))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd(screenlock))

------------------------------
---- WINDOW MANAGEMENT -------
------------------------------
hl.bind("SUPER + Tab", function()
    hl.dispatch(hl.dsp.window.cycle_next())    -- Change focus to another window
    hl.dispatch(hl.dsp.window.bring_to_top()) -- Bring it to the top
end)
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ state = 2 }))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ state = 2 }))
hl.bind(mainMod .. " + T",         hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.window.center())
hl.bind(mainMod .. " + G",         hl.dsp.group.toggle())
hl.bind(mainMod .. " + Tab",       hl.dsp.group.next())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))

-- Move focus  [←][↑][↓][→]
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Move window  [←][↑][↓][→]
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "d" }))

------------------------------
---- WORKSPACE NAVIGATION ----
------------------------------
-- 1–6 use a custom go_through script; 7–10 switch directly
for i = 1, 6 do
    hl.bind(mainMod .. " + " .. i, hl.dsp.exec_cmd("/home/jack/.scripts/go_through.sh " .. i))
end
hl.bind(mainMod .. " + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind(mainMod .. " + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind(mainMod .. " + 9", hl.dsp.focus({ workspace = 9 }))
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))

-- Move ALL windows to workspace (custom script)
for i = 1, 9 do
    hl.bind(mainMod .. " + ALT + " .. i, hl.dsp.exec_cmd("/home/jack/.scripts/moving_all_windows.sh " .. i))
end
hl.bind(mainMod .. " + ALT + 0", hl.dsp.exec_cmd("/home/jack/.scripts/moving_all_windows.sh 10"))

-- Move active window to workspace
for i = 1, 7 do
    hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

-- Special workspaces
hl.bind(mainMod .. " + SHIFT + Space", hl.dsp.workspace.toggle_special("minimize"))
hl.bind(mainMod .. " + ALT + Space",   hl.dsp.window.move({ workspace = "special:minimize", follow = false }))
hl.bind(mainMod .. " + SHIFT + N",     hl.dsp.workspace.toggle_special("network_social"))
hl.bind(mainMod .. " + ALT + N",   hl.dsp.window.move({ workspace = "special:network_social", follow = false }))

------------------------------
---- MEDIA / HARDWARE --------
------------------------------
-- hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +2%; pkill -RTMIN+8 waybar"), { locked = true, repeating = true  }) 
-- hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -2%; pkill -RTMIN+8 waybar"), { locked = true, repeating = true  }) 
-- hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle; pkill -RTMIN+8 waybar"), { locked = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("~/.config/eww/scripts/volume.sh up"), { locked = true, repeating = true  }) 
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("~/.config/eww/scripts/volume.sh down"), { locked = true, repeating = true  }) 
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("~/.config/eww/scripts/volume.sh mute"), { locked = true })



hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("~/.config/eww/scripts/brightness.sh up"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("~/.config/eww/scripts/brightness.sh down"),  { locked = true, repeating = true })


hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })