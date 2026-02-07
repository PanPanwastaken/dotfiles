#!/bin/bash
# Homescreen - Fast parallel window spawning

THEMES_DIR="$HOME/themes"
CURRENT_THEME_FILE="$THEMES_DIR/.current"

get_current_theme() {
    cat "$CURRENT_THEME_FILE" 2>/dev/null || echo "astolfo"
}

load_layout() {
    local layout_file="$THEMES_DIR/$(get_current_theme)/layout.conf"
    if [[ -f "$layout_file" ]]; then
        source "$layout_file"
    else
        HACKERNEWS_SIZE="882 391"; HACKERNEWS_POS="272 172"
        NOWPLAYING_SIZE="519 143"; NOWPLAYING_POS="261 52"
        GOTOP_SIZE="580 497"; GOTOP_POS="3 532"
        NVTOP_SIZE="580 497"; NVTOP_POS="583 532"
        CAVA_SIZE="484 85"; CAVA_POS="668 139"
        ASTROTERM_SIZE="580 400"; ASTROTERM_POS="583 50"
    fi
}

# Fast window positioning (no wait loop)
position_window() {
    local class="$1" size="$2" pos="$3"
    local w=${size% *} h=${size#* } x=${pos% *} y=${pos#* }

    sleep 0.3  # Brief wait for window to appear
    local addr=$(hyprctl clients -j | jq -r ".[] | select(.class == \"$class\") | .address" | head -1)
    [[ -n "$addr" && "$addr" != "null" ]] && {
        hyprctl --batch "dispatch movetoworkspacesilent 99,address:$addr; dispatch setfloating address:$addr; dispatch resizewindowpixel exact $w $h,address:$addr; dispatch movewindowpixel exact $x $y,address:$addr"
    }
}

load_layout

# Spawn all windows in parallel
kitty --config ~/.config/kitty/homescreen-clx.conf --class "homescreen-hackernews" --hold -e clx &
kitty --config ~/.config/kitty/homescreen.conf --class "homescreen-nowplaying" --hold -e ~/.config/panscripts/now_playing.sh &
kitty --config ~/.config/kitty/homescreen-clx.conf --class "homescreen-gotop" --hold -e gotop &
kitty --config ~/.config/kitty/homescreen-clx.conf --class "homescreen-nvtop" --hold -e nvtop &
kitty --config ~/.config/kitty/homescreen.conf --class "homescreen-cava" --hold -e cava &
[[ -n "$ASTROTERM_SIZE" ]] && kitty --config ~/.config/kitty/homescreen-clx.conf --class "homescreen-astroterm" --hold -e astroterm --city=Vancouver --color --constellations -s 100 &

# Position all windows in parallel
position_window "homescreen-hackernews" "$HACKERNEWS_SIZE" "$HACKERNEWS_POS" &
position_window "homescreen-nowplaying" "$NOWPLAYING_SIZE" "$NOWPLAYING_POS" &
position_window "homescreen-gotop" "$GOTOP_SIZE" "$GOTOP_POS" &
position_window "homescreen-nvtop" "$NVTOP_SIZE" "$NVTOP_POS" &
position_window "homescreen-cava" "$CAVA_SIZE" "$CAVA_POS" &
[[ -n "$ASTROTERM_SIZE" ]] && position_window "homescreen-astroterm" "$ASTROTERM_SIZE" "$ASTROTERM_POS" &

wait
