#!/usr/bin/env bash
#
# theme-menu.sh - Rofi menu for theme selection
#

THEMES_DIR="$HOME/themes"
SCRIPTS_DIR="$THEMES_DIR/scripts"
CURRENT_THEME_FILE="$THEMES_DIR/.current"

get_current() {
    [[ -f "$CURRENT_THEME_FILE" ]] && cat "$CURRENT_THEME_FILE" || echo ""
}

build_menu() {
    local current=$(get_current)

    for d in "$THEMES_DIR"/*/; do
        [[ -d "$d" && -f "$d/theme.conf" ]] || continue
        local name=$(basename "$d")
        source "$d/theme.conf" 2>/dev/null

        local marker=""
        [[ "$current" == "$name" ]] && marker="  "
        echo "$marker$name - ${THEME_DESCRIPTION:-}"
    done
}

selected=$(build_menu | rofi -dmenu \
    -p " Theme" \
    -theme ~/.config/rofi/launchers/type-2/theme-menu.rasi \
    2>/dev/null)

[[ -z "$selected" ]] && exit 0

# Extract theme name (strip marker and description)
theme_name=$(echo "$selected" | sed 's/^[  ]*//' | cut -d' ' -f1)

exec "$SCRIPTS_DIR/theme-apply.sh" "$theme_name"
