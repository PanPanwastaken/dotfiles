#!/bin/bash
# mini_player.sh - Toggle PiP window visibility / close it
# Super+Shift+P: if PiP exists, close it and stop monitor

APPID="miniplayer"
PIDFILE="/tmp/pip-monitor.pid"

if hyprctl clients -j | jq -e ".[] | select(.title | startswith(\"$APPID\"))" &>/dev/null; then
    hyprctl clients -j | jq -r ".[] | select(.title | startswith(\"$APPID\")) | .address" | \
        xargs -I{} hyprctl dispatch closewindow address:{}
    [[ -f "$PIDFILE" ]] && kill "$(cat "$PIDFILE")" 2>/dev/null && rm -f "$PIDFILE"
    notify-send "Mini Player" "Stopped" -i dialog-info
else
    notify-send "Mini Player" "Use ,p in qutebrowser to start PiP" -i dialog-info
fi
