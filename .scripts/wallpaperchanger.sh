#!/bin/bash
SEL_WALLPAPER=$(hellpaper /home/jack/wallpapers/static_unsorted_wallpapers/)
swaybg -i "$SEL_WALLPAPER" &
matugen image "$SEL_WALLPAPER" &
cp "$SEL_WALLPAPER" ~/.config/hellpaper/wall
