#!/bin/bash

status=$(cat /sys/class/power_supply/BAT1/status)
capacity=$(cat /sys/class/power_supply/BAT1/capacity)

if [[ "$status" == "Charging" ]] || [[ "$status" == "Full" ]]; then
    powerprofilesctl set performance
else
    if [[ "$capacity" -lt 30 ]]; then
        powerprofilesctl set power-saver
    else
        powerprofilesctl set balanced
    fi
fi
