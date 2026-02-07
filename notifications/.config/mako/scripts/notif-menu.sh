#!/bin/bash

# Small delay to avoid click propagation from waybar
sleep 0.1

# Get current notifications
notifs=$(makoctl list 2>/dev/null | grep "Notification" | sed 's/Notification [0-9]*: //')

if [ -z "$notifs" ]; then
    selected=$(echo -e "No notifications" | rofi -dmenu -p "󰂜 Notifications" -theme ~/.config/mako/scripts/notif-menu.rasi -normal-window)
else
    selected=$(echo -e "󰎟 Clear All\n$notifs" | rofi -dmenu -p "󰂜 Notifications" -theme ~/.config/mako/scripts/notif-menu.rasi -normal-window)

    if [[ "$selected" == *"Clear All"* ]]; then
        makoctl dismiss -a
    fi
fi
