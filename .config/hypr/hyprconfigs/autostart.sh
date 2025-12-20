#!/usr/bin/bash

export QT_QPA_PLATFORMTHEME=qt5ct
export QT_QPA_PLATFORMTHEME=qt6ct
hyprctl setcursor "Bocchi-The-Cursor" 24


# bar/panel
#./.config/waybar/waybar-switcher/current.sh &
#hyprpanel &

# wallpaper
# hyprpaper &
#swww-daemon &
python /home/jack/.config/hypr/wallpaperslideshow.py &
# swaybg -i ~/.config/hellpaper/wall &


# Applets
nm-applet &
elephant &

#notifications
swaync &

# applications

Telegram -startintray &
discord --start-minimized && hyprctl dispatch minimize active &
# unityhub &
# protonvpn-app &
fdm --minimized &
# heroic &
# steam -silent &
kdeconnectd &

# hypridle the automatic lock
hypridle &

# other
wl-paste --watch cliphist store &

