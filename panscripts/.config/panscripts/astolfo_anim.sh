#!/usr/bin/env bash
# Astolfo ASCII animation player (ping-pong loop) with colors

ANIM_DIR="$HOME/.config/fastfetch/anim"
FRAME_DELAY=0.5

# Astolfo theme colors
PINK='\033[38;2;255;110;180m'
LIGHT_PINK='\033[38;2;255;142;196m'
BLUE='\033[38;2;127;219;255m'
PURPLE='\033[38;2;180;144;212m'
RESET='\033[0m'

# Pre-read all frames into memory
frames=()
for frame in "$ANIM_DIR"/frame*.txt; do
    [[ -f "$frame" ]] && frames+=("$(cat "$frame")")
done

if [[ ${#frames[@]} -eq 0 ]]; then
    echo "No frames found in $ANIM_DIR"
    exit 1
fi

# Hide cursor
printf '\033[?25l'
trap 'printf "\033[?25h"' EXIT

# Clear screen once at start
clear

colorize_frame() {
    local line_num=0
    while IFS= read -r line; do
        ((line_num++))
        if ((line_num <= 10)); then
            printf "  ${PINK}%s${RESET}\n" "$line"
        elif ((line_num <= 18)); then
            printf "  ${LIGHT_PINK}%s${RESET}\n" "$line"
        elif ((line_num <= 24)); then
            printf "  ${PURPLE}%s${RESET}\n" "$line"
        else
            printf "  ${BLUE}%s${RESET}\n" "$line"
        fi
    done
}

while true; do
    # Forward direction
    for frame_content in "${frames[@]}"; do
        printf '\033[H\033[J'
        echo
        colorize_frame <<< "$frame_content"
        sleep "$FRAME_DELAY"
    done

    # Backward direction (skip first and last to avoid duplicate frames)
    for ((i=${#frames[@]}-2; i>0; i--)); do
        printf '\033[H\033[J'
        echo
        colorize_frame <<< "${frames[$i]}"
        sleep "$FRAME_DELAY"
    done
done
