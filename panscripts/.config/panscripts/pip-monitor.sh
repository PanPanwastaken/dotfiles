#!/bin/bash
# pip-monitor.sh - PiP workspace auto-show/hide
# Usage: pip-monitor.sh <source_workspace>

SOURCE_WS="$1"
HOME_WS="99"
APPID="miniplayer"
PIDFILE="/tmp/pip-monitor.pid"
SOCK="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
QUTE_IPC=$(find "$XDG_RUNTIME_DIR/qutebrowser/" -name 'ipc-*' 2>/dev/null | head -1)

echo $$ > "$PIDFILE"
trap 'rm -f "$PIDFILE"; exit' EXIT INT TERM

qute_cmd() {
    [[ -z "$QUTE_IPC" || ! -S "$QUTE_IPC" ]] && QUTE_IPC=$(find "$XDG_RUNTIME_DIR/qutebrowser/" -name 'ipc-*' 2>/dev/null | head -1)
    echo "{\"args\": [\":$1\"], \"target_arg\": null, \"version\": \"1.0.0\", \"protocol_version\": 1, \"cwd\": \"$HOME\"}" \
        | socat - UNIX-CONNECT:"$QUTE_IPC" 2>/dev/null
}

PIP_W=327
PIP_H=178
PIP_X=1575
PIP_Y=54

# Find the workspace of the main qutebrowser window dynamically
get_qute_ws() {
    hyprctl clients -j | jq -r \
        "[.[] | select(.class | test(\"qutebrowser\"; \"i\")) | select(.title | startswith(\"$APPID\") | not)][0].workspace.id // \"$SOURCE_WS\""
}

ADDR=""

socat -U - "UNIX-CONNECT:$SOCK" | while IFS= read -r line; do
    if [[ -z "$ADDR" ]]; then
        # Phase 1: Detect miniplayer window via openwindow event
        case "$line" in
            openwindow\>\>*)
                info="${line#openwindow>>}"
                IFS=',' read -r raw_addr orig_ws cls ttl <<< "$info"
                new_addr="0x$raw_addr"
                [[ "$cls" == *qutebrowser* ]] || continue
                # Immediately hide to prevent visual flash
                hyprctl dispatch movetoworkspacesilent "special:pip,address:$new_addr"
                sleep 0.2
                title=$(hyprctl clients -j | jq -r ".[] | select(.address == \"$new_addr\") | .title // empty")
                if [[ "$title" == miniplayer* ]]; then
                    ADDR="$new_addr"
                    hyprctl dispatch setprop "address:$ADDR" border_size 0
                    hyprctl dispatch setprop "address:$ADDR" no_shadow on
                    hyprctl dispatch resizewindowpixel "exact $PIP_W $PIP_H,address:$ADDR"
                    hyprctl dispatch movewindowpixel "exact $PIP_X $PIP_Y,address:$ADDR"
                    # Restore bars if main qutebrowser window is focused
                    focused=$(hyprctl activewindow -j | jq -r '.class // empty')
                    focused_title=$(hyprctl activewindow -j | jq -r '.title // empty')
                    if [[ "$focused" == *qutebrowser* && "$focused_title" != miniplayer* ]]; then
                        qute_cmd "set statusbar.show always"
                        qute_cmd "set tabs.show always"
                    fi
                else
                    # Not the miniplayer, move it back
                    hyprctl dispatch movetoworkspacesilent "$orig_ws,address:$new_addr"
                fi
                ;;
        esac
    else
        # Phase 2: Monitor workspace changes
        case "$line" in
            workspace\>\>*)
                ws="${line#workspace>>}"
                ws="${ws%%[[:space:]]}"
                # Exit if miniplayer was closed
                hyprctl clients -j | jq -e ".[] | select(.address == \"$ADDR\")" &>/dev/null || exit 0
                qute_ws=$(get_qute_ws)
                if [[ "$ws" == "$qute_ws" || "$ws" == "$HOME_WS" ]]; then
                    hyprctl dispatch movetoworkspacesilent "special:pip,address:$ADDR"
                else
                    hyprctl dispatch movetoworkspacesilent "$ws,address:$ADDR"
                    hyprctl dispatch setfloating "address:$ADDR"
                    hyprctl dispatch resizewindowpixel "exact $PIP_W $PIP_H,address:$ADDR"
                    hyprctl dispatch movewindowpixel "exact $PIP_X $PIP_Y,address:$ADDR"
                fi
                ;;
        esac
    fi
done
