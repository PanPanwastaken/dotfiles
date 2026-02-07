#!/bin/bash
# qute-bar-monitor.sh - Show qutebrowser bars only when main window is focused
# Runs on startup via hyprland exec-once

APPID="miniplayer"
SOCK="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
QUTE_IPC=$(find "$XDG_RUNTIME_DIR/qutebrowser/" -name 'ipc-*' 2>/dev/null | head -1)
BARS_SHOWN=false

qute_cmd() {
    echo "{\"args\": [\":$1\"], \"target_arg\": null, \"version\": \"1.0.0\", \"protocol_version\": 1, \"cwd\": \"$HOME\"}" \
        | socat - UNIX-CONNECT:"$QUTE_IPC" 2>/dev/null
}

show_bars() {
    if [[ "$BARS_SHOWN" == false ]]; then
        [[ -z "$QUTE_IPC" || ! -S "$QUTE_IPC" ]] && QUTE_IPC=$(find "$XDG_RUNTIME_DIR/qutebrowser/" -name 'ipc-*' 2>/dev/null | head -1)
        qute_cmd "set statusbar.show always"
        qute_cmd "set tabs.show always"
        BARS_SHOWN=true
    fi
}

hide_bars() {
    if [[ "$BARS_SHOWN" == true ]]; then
        [[ -z "$QUTE_IPC" || ! -S "$QUTE_IPC" ]] && QUTE_IPC=$(find "$XDG_RUNTIME_DIR/qutebrowser/" -name 'ipc-*' 2>/dev/null | head -1)
        qute_cmd "set statusbar.show never"
        qute_cmd "set tabs.show never"
        BARS_SHOWN=false
    fi
}

socat -U - "UNIX-CONNECT:$SOCK" | while IFS= read -r line; do
    case "$line" in
        activewindow\>\>*)
            info="${line#activewindow>>}"
            IFS=',' read -r cls ttl <<< "$info"
            if [[ "$cls" == *qutebrowser* && "$ttl" != miniplayer* ]]; then
                show_bars
            else
                hide_bars
            fi
            ;;
    esac
done
