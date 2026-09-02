#!/usr/bin/bash

export QT_QPA_PLATFORMTHEME=qt5ct
export QT_QPA_PLATFORMTHEME=qt6ct
hyprctl setcursor "miku-cursor-linux" 32

# bar/panel
./.config/waybar/waybar-switcher/current.sh &
#hyprpanel &

# wallpaper
# hyprpaper &
#awww-daemon &
skwd-daemon &
# python /home/jack/.config/hypr/wallpaperslideshow.py &
# swaybg -i ~/.config/hellpaper/wall &
# quickshell &

# Applets
nm-applet &

#notifications
swaync &

# applications
Telegram -startintray &
vesktop --start-minimized && hyprctl dispatch minimize active &
# unityhub &
# protonvpn-app &
fdm --minimized &
heroic &
steam -silent &
kdeconnectd &

# hypridle the automatic lock
hypridle &

# other
# mpd ~/.config/mpd/mpd.conf &
mouse_invert &
wl-paste --watch cliphist store &
