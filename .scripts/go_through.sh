#!/bin/bash

# Check if argument is provided
if [ $# -eq 0 ]; then
    echo "Error: No target workspace specified"
    echo "Usage: $0 <workspace_number>"
    exit 1
fi

target=$1

# Get current workspace
current_workspace=$(hyprctl activeworkspace -j | jq '.id')

# Validate input is numeric
if ! [[ $target =~ ^[0-9]+$ ]]; then
    echo "Error: Target workspace must be a number"
    exit 1
fi

if [ "$target" -gt "$current_workspace" ]; then
    # Move forward through workspaces
    for ((i=current_workspace; i<=target; i++)); do
        hyprctl dispatch workspace "$i"
        sleep 0.05
    done
elif [ "$target" -lt "$current_workspace" ]; then
    # Move backward through workspaces
    for ((i=current_workspace; i>=target; i--)); do
        hyprctl dispatch workspace "$i"
        sleep 0.05
    done
fi
