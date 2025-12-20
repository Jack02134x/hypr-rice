#!/bin/bash

# Show Wofi menu for selection
show_menu() {
    local prompt="$1"
    shift
    local options=("$@")
    printf "%s\n" "${options[@]}" | wofi --show dmenu --prompt="$prompt"
}

# Main function
main() {

    # Step 1: Ask for mode
    local mode
    mode=$(show_menu "search" $(ls ~/.config/waybar/themes/) )
    [[ -z "$mode" ]] && exit 0 # Exit if no selection

    # Step 2: change waybar
    pkill waybar; pkill bongocat; waybar --config ~/.config/waybar/themes/$mode/config.jsonc --style ~/.config/waybar/themes/$mode/style.css & bongocat -c ~/.config/waybar/themes/$mode/$mode-bongo.conf &

    # Step 3: Keep track of current waybar
    echo "pkill waybar; pkill bongocat; waybar --config ~/.config/waybar/themes/$mode/config.jsonc --style ~/.config/waybar/themes/$mode/style.css & bongocat -c ~/.config/waybar/themes/$mode/$mode-bongo.conf &" > ~/.config/waybar/waybar-switcher/current.sh
}

main
