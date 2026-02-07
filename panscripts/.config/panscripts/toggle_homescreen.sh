#!/bin/bash
# Fast workspace toggle - kills windows to save GPU

PREV_WS_FILE="/tmp/homescreen_prev_ws"
ORIG_WP_FILE="/tmp/homescreen_orig_wp"
DIM_CACHE_DIR="/tmp/homescreen_dim_cache"
HOMESCREEN_WS=99

mkdir -p "$DIM_CACHE_DIR"

kill_homescreen() {
    hyprctl clients -j | jq -r '.[] | select(.class | startswith("homescreen-")) | .address' | \
        xargs -I{} hyprctl dispatch closewindow address:{} &>/dev/null

}

get_current_wallpaper() {
    swww query | grep -oP '(?<=image: ).*' | head -1
}

is_dimmed_wallpaper() {
    [[ "$1" == "$DIM_CACHE_DIR"* ]]
}

get_dimmed_wallpaper() {
    local orig="$1"
    local hash=$(echo "$orig" | md5sum | cut -d' ' -f1)
    local dimmed="$DIM_CACHE_DIR/${hash}_dim.png"

    [[ ! -f "$dimmed" ]] && {
        magick "$orig" \( +clone -blur 0x60 \) -fx "u*(1-i/w) + v*(i/w)" -fill black -colorize 40% -modulate 80,100,100 "$dimmed"
    }
    echo "$dimmed"
}

current_ws=$(hyprctl activeworkspace -j | jq '.id')

if [[ "$current_ws" == "$HOMESCREEN_WS" ]]; then
    # Leaving homescreen
    kill_homescreen &

    [[ -f "$ORIG_WP_FILE" ]] && {
        orig_wp=$(cat "$ORIG_WP_FILE")
        [[ -f "$orig_wp" ]] && swww img "$orig_wp" --transition-type fade --transition-duration 0.15 &
    }

    hyprctl dispatch workspace "$(cat "$PREV_WS_FILE" 2>/dev/null || echo 1)"
else
    # Going to homescreen
    echo "$current_ws" > "$PREV_WS_FILE"

    current_wp=$(get_current_wallpaper)
    if [[ -n "$current_wp" && -f "$current_wp" ]] && ! is_dimmed_wallpaper "$current_wp"; then
        echo "$current_wp" > "$ORIG_WP_FILE"
        dimmed_wp=$(get_dimmed_wallpaper "$current_wp")
        swww img "$dimmed_wp" --transition-type fade --transition-duration 0.15 &
    fi

    hyprctl dispatch workspace $HOMESCREEN_WS
    ~/.config/panscripts/homescreen.sh &
fi
