#!/usr/bin/env bash

length=$(playerctl metadata --format '{{mpris:length}}' 2>/dev/null)
position=$(playerctl position 2>/dev/null)

[ -z "$length" ] && exit 0
[ -z "$position" ] && exit 0

length_sec=$((length / 1000000))
pos_sec=${position%.*}

(( length_sec == 0 )) && exit 0

width=24
filled=$(( pos_sec * width / length_sec ))

for ((i=0;i<width;i++)); do
    if (( i < filled )); then
        printf "█"
    else
        printf "░"
    fi
done

printf "\n"
