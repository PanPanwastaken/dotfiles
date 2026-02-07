#!/bin/bash

mode="$1"
query="$2"

if [ "$mode" = "pacman" ]; then
    results=$(pacman -Ss "$query" 2>/dev/null | paste - - | sed 's/^[[:space:]]*//')
    selected=$(echo "$results" | rofi -dmenu -i -p "󰏖 pkg" -theme ~/.config/mako/scripts/notif-menu.rasi)
    [ -z "$selected" ] && exit 0
    pkg=$(echo "$selected" | awk '{print $1}' | cut -d'/' -f2)
    [ -n "$pkg" ] && kitty -e sudo pacman -S "$pkg"
else
    results=$(yay -Ss "$query" 2>/dev/null | paste - - | sed 's/^[[:space:]]*//')
    selected=$(echo "$results" | rofi -dmenu -i -p "󰏖 aur" -theme ~/.config/mako/scripts/notif-menu.rasi)
    [ -z "$selected" ] && exit 0
    pkg=$(echo "$selected" | awk '{print $1}' | cut -d'/' -f2)
    [ -n "$pkg" ] && kitty -e yay -S "$pkg"
fi
