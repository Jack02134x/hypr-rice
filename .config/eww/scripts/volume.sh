#!/bin/bash

case "$1" in
    up)
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
        ;;
    down)
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
        ;;
    mute)
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        ;;
esac

volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)

value=$(echo "$volume" | awk '{printf "%.0f", $2 * 100}')

if echo "$volume" | grep -q MUTED; then
    icon="󰖁"
    value=0
else
    if [ "$value" -eq 0 ]; then
        icon="󰕿"
    elif [ "$value" -lt 50 ]; then
        icon="󰖀"
    elif [ "$value" -gt 100 ]; then
        $( wpctl set-volume @DEFAULT_AUDIO_SINK@ 1 )
        icon="󰕾"
    else
        icon="󰕾"
    fi
fi

eww update \
    osd_type="Volume" \
    osd_value="$value" \
    osd_icon="$icon"

eww open osd

sleep 2

eww close osd