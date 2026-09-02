#!/bin/bash

case "$1" in
    up)
        brightnessctl set 5%+
        ;;
    down)
        brightnessctl set 5%-
        ;;
esac

value=$(brightnessctl get)
max=$(brightnessctl max)

value=$((value * 100 / max))

if [ "$value" -lt 20 ]; then
    icon="󰃞"
elif [ "$value" -lt 60 ]; then
    icon="󰃟"
else
    icon="󰃠"
fi

eww update \
    osd_type="Brightness" \
    osd_value="$value" \
    osd_icon="$icon"

eww open osd

sleep 2

eww close osd