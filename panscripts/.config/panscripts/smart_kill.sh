#!/bin/bash

# Smart Kill - Block closing homescreen windows
# Used as replacement for killactive keybind

# Get the focused window class
CLASS=$(hyprctl activewindow -j | jq -r '.class // ""')

# If it's a homescreen window, do nothing
if [[ "$CLASS" == homescreen-* ]]; then
    exit 0
fi

# Otherwise, kill the active window
hyprctl dispatch killactive
