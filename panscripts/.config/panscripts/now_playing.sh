#!/bin/bash
# Now playing display using playerctl
# Colors from theme (reloaded each cycle)

THEME_CONF="$HOME/.config/panscripts/player-theme.conf"
RESET='\033[0m'

# Hide cursor
printf '\033[?25l'
trap 'printf "\033[?25h"' EXIT

while true; do
    # Reload theme colors each cycle
    if [[ -f "$THEME_CONF" ]]; then
        source "$THEME_CONF"
    else
        PRIMARY_R=255 PRIMARY_G=110 PRIMARY_B=180
        SECONDARY_R=127 SECONDARY_G=219 SECONDARY_B=255
    fi
    PRIMARY="\033[38;2;${PRIMARY_R};${PRIMARY_G};${PRIMARY_B}m"
    SECONDARY="\033[38;2;${SECONDARY_R};${SECONDARY_G};${SECONDARY_B}m"
    clear
    status=$(playerctl status 2>/dev/null)
    if [[ "$status" == "Playing" || "$status" == "Paused" ]]; then
        artist=$(playerctl metadata artist 2>/dev/null)
        title=$(playerctl metadata title 2>/dev/null)
        album=$(playerctl metadata album 2>/dev/null)

        echo ""
        if [[ "$status" == "Playing" ]]; then
            echo -e "  ${PRIMARY}▶ Now Playing${RESET}"
        else
            echo -e "  ${SECONDARY}⏸ Paused${RESET}"
        fi
        echo ""
        echo -e "  ${PRIMARY}$title${RESET}"
        [[ -n "$artist" ]] && echo -e "  ${SECONDARY}$artist${RESET}"
        [[ -n "$album" ]] && echo -e "  ${SECONDARY}$album${RESET}"
    else
        echo ""
        echo -e "  ${PRIMARY}♪${RESET} ${SECONDARY}Nothing playing${RESET}"
    fi
    sleep 2
done
