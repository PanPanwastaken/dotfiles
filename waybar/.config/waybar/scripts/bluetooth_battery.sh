#!/usr/bin/env bash
# ~/.config/waybar/scripts/bluetooth_battery.sh

# Get connected Bluetooth devices
device_name=$(bluetoothctl devices Connected 2>/dev/null | head -n1 | cut -d' ' -f3-)

if [ -z "$device_name" ]; then
    echo "None"
    exit 0
fi

# Try to get battery from upower
battery=$(upower -d | grep -A 20 "$device_name" | grep "percentage" | awk '{print $2}' | tr -d '%')

if [ -n "$battery" ]; then
    echo "${device_name} ${battery}%"
else
    echo "${device_name}"
fi
