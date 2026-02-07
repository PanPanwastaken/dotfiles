#!/bin/bash
# Screen recording toggle (rofi + theme-aware)

RECORDINGS_DIR="$HOME/Videos/Recordings"
MENU_THEME="$HOME/.config/panscripts/panmenu.rasi"
mkdir -p "$RECORDINGS_DIR"

PIDFILE="/tmp/screenrecord.pid"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
FILENAME="$RECORDINGS_DIR/recording-$TIMESTAMP.mp4"

if [[ -f "$PIDFILE" ]]; then
    # Stop recording
    PID=$(cat "$PIDFILE")
    kill -INT "$PID" 2>/dev/null
    rm -f "$PIDFILE"
    notify-send "Screen Recording" "Recording stopped" -i video-x-generic
else
    # Start recording menu
    CHOICE=$(printf '󰹑  Fullscreen\n󰩭  Region' | rofi -dmenu \
        -p "󰻃 Record" \
        -theme "$MENU_THEME" \
        -theme-str "listview { lines: 2; }" \
        2>/dev/null)

    case "$CHOICE" in
        *"Fullscreen")
            notify-send "Screen Recording" "Recording started..." -i video-x-generic
            wf-recorder -f "$FILENAME" &
            echo $! > "$PIDFILE"
            ;;
        *"Region")
            REGION=$(slurp)
            if [[ -n "$REGION" ]]; then
                notify-send "Screen Recording" "Recording started..." -i video-x-generic
                wf-recorder -g "$REGION" -f "$FILENAME" &
                echo $! > "$PIDFILE"
            fi
            ;;
    esac
fi
