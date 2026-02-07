#!/usr/bin/env bash
# ~/.config/waybar/scripts/taskbar.sh

ICONS=(
  ["Firefox"]=""
  ["Chromium"]=""
  ["Code"]=""
  ["Alacritty"]=""
  ["VLC"]=""
  ["Spotify"]=""
  ["Thunderbird"]=""
  ["Discord"]="ﭮ"
  ["Telegram"]=""
)

# Get open windows
windows=$(hyprctl clients -j | jq -r '.[].class')

output=""
for w in $windows; do
    icon=${ICONS[$w]:-}
    output+="$icon "
done

echo "$output"
