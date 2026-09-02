#!/bin/bash
cur_wall=$( cat ~/.scripts/wallname.txt )
power=$(powerprofilesctl get)

show_menu() {
    local prompt="$1"
    shift
    local options=("$@")
    printf "%s\n" "${options[@]}" | wofi --show dmenu --prompt="$prompt"
}

main() {
    check_dependencies
    local choice=$(show_menu "Quick Settings" "Bluetooth"  "Hypr" "Waybar" "Scripts" "Study Music" "Always on on" "Always on off" "Current wallpaper" "Power Mode" "Projects" "Fix Monitor")
    case "$choice" in
        "Bluetooth") kitty -e bluetuith ;;
        "Hypr") code ~/.config/hypr/ ;;
        "Waybar") code ~/.config/waybar/ ;;
        "Scripts") code ~/.scripts ;;
        "Study Music") ffplay -f lavfi -i anoisesrc=c='brown' -loop 0 ;;
        "Always on on") pkill hypridle & notify-send --app-name "Hypr" -i ~/.config/notify-send/hypr_icon.png "Always on is on      " ;;
        "Always on off") hypridle & notify-send  --app-name "Hypr" -i  ~/.config/notify-send/hypr_icon.png "Always on is off      " ;;
        "Current wallpaper") notify-send --app-name "Wallpaper" -i  ~/.config/notify-send/wallpaper_icon.png "current wallpaper : $cur_wall"; wl-copy $cur_wall ;;
        "Power Mode")  notify-send --app-name "Power Manager" -i  ~/.config/notify-send/power_icon.png "Power set to $power" ;;
        "Projects") code ~/Projects;;
        "Fix Monitor") hyprctl dispatch 'hl.dsp.dpms({ action = "disable", monitor = "HDMI-A-1"})'; sleep 1; hyprctl dispatch 'hl.dsp.dpms({ action = "enable", monitor = "HDMI-A-1"})'
    esac
}

main
