#!/bin/bash

# Move all windows from the active workspace to another workspace
# Usage: move_workspace.sh <target_workspace>

target_ws="$1"

if [[ -z "$target_ws" ]]; then
    echo "Usage: $0 <target_workspace>"
    exit 1
fi

# Current workspace of focused window
current_ws=$(hyprctl activewindow -j | jq -r '.workspace.id')

if [[ -z "$current_ws" || "$current_ws" == "null" ]]; then
    echo "Could not determine active workspace"
    exit 1
fi

echo "Moving windows from workspace $current_ws to workspace $target_ws"

# Get addresses of all windows on current workspace
hyprctl clients -j |
jq -r ".[] | select(.workspace.id == $current_ws) | .address" |
while read -r addr; do

    echo "Moving $addr"

    # Focus window by address
    hyprctl dispatch "
        hl.dsp.focus({
            window = 'address:$addr'
        })
    " >/dev/null

    # Move focused window
    hyprctl dispatch "
        hl.dsp.window.move({
            workspace = '$target_ws',
            follow = false
        })
    " >/dev/null

done

echo "Done"

hyprctl dispatch "hl.dsp.focus({ workspace = '$target_ws' })"
