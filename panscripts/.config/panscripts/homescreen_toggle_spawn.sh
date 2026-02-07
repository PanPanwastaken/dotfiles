#!/bin/bash
# Toggle homescreen: kill if running, spawn if not

count=$(hyprctl clients -j | jq '[.[] | select(.class | startswith("homescreen-"))] | length')

if [[ "$count" -gt 0 ]]; then
    # Kill all homescreen windows
    hyprctl clients -j | jq -r '.[] | select(.class | startswith("homescreen-")) | .address' | xargs -I{} hyprctl dispatch closewindow address:{}
else
    # Spawn homescreen
    ~/.config/panscripts/homescreen.sh
fi
