#!/bin/bash
# Screenshot menu with gallery preview (rofi + theme-aware)

SCREENSHOTS_DIR="$HOME/Pictures/Screenshots"
CACHE_DIR="$HOME/.cache/screenshot-thumbs"
MENU_THEME="$HOME/.config/panscripts/panmenu.rasi"
mkdir -p "$SCREENSHOTS_DIR" "$CACHE_DIR"

TIMESTAMP=$(date +%Y%m%d-%H%M%S)
FILENAME="$SCREENSHOTS_DIR/screenshot-$TIMESTAMP.png"

# Generate thumbnail for a screenshot
gen_thumb() {
    local src="$1"
    local name=$(basename "$src" .png)
    local thumb="$CACHE_DIR/${name}_thumb.png"

    if [[ ! -f "$thumb" || "$src" -nt "$thumb" ]]; then
        magick "$src" -resize 120x80^ -gravity center -extent 120x80 "$thumb" 2>/dev/null
    fi
    echo "$thumb"
}

# Build menu entries
build_menu() {
    echo "󰹑  Capture Fullscreen"
    echo "󰩭  Capture Region"
    echo "󰖯  Capture Window"
    echo "󰆏  Region → Clipboard"
    echo "󰨇  Fullscreen + Edit"
    echo "󰩭  Region + Edit"

    # Recent screenshots with thumbnails
    for img in $(ls -t "$SCREENSHOTS_DIR"/*.png 2>/dev/null | head -10); do
        local name=$(basename "$img")
        local thumb=$(gen_thumb "$img")
        local date=$(echo "$name" | grep -oP '\d{8}-\d{6}' | sed 's/\([0-9]\{4\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)-\([0-9]\{2\}\)\([0-9]\{2\}\).*/\1-\2-\3 \4:\5/')
        printf '%s\0icon\x1f%s\n' "  $date" "$thumb"
    done
}

# Count lines for listview height
MENU_LINES=6
RECENT_COUNT=$(ls -t "$SCREENSHOTS_DIR"/*.png 2>/dev/null | head -10 | wc -l)
[[ $RECENT_COUNT -gt 0 ]] && MENU_LINES=$((6 + RECENT_COUNT))

# Show rofi menu
CHOICE=$(build_menu | rofi -dmenu \
    -p " Screenshot" \
    -mesg "$([ $RECENT_COUNT -gt 0 ] && echo "Recent screenshots below")" \
    -show-icons \
    -theme "$MENU_THEME" \
    -theme-str "listview { lines: $MENU_LINES; }" \
    2>/dev/null)

[[ -z "$CHOICE" ]] && exit 0

# Handle choice
case "$CHOICE" in
    *"Capture Fullscreen")
        sleep 0.2
        grim "$FILENAME"
        notify-send "Screenshot" "Saved to $FILENAME" -i "$FILENAME"
        ;;
    *"Capture Region")
        grim -g "$(slurp)" "$FILENAME"
        notify-send "Screenshot" "Saved to $FILENAME" -i "$FILENAME"
        ;;
    *"Capture Window")
        WINDOW=$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
        grim -g "$WINDOW" "$FILENAME"
        notify-send "Screenshot" "Saved to $FILENAME" -i "$FILENAME"
        ;;
    *"Clipboard")
        grim -g "$(slurp)" - | wl-copy
        notify-send "Screenshot" "Copied to clipboard"
        ;;
    *"Fullscreen + Edit")
        sleep 0.2
        grim - | satty --filename - --output-filename "$FILENAME"
        [[ -f "$FILENAME" ]] && notify-send "Screenshot" "Saved to $FILENAME" -i "$FILENAME"
        ;;
    *"Region + Edit")
        grim -g "$(slurp)" - | satty --filename - --output-filename "$FILENAME"
        [[ -f "$FILENAME" ]] && notify-send "Screenshot" "Saved to $FILENAME" -i "$FILENAME"
        ;;
    *"  "*)
        # Clicked on a recent screenshot
        DATE=$(echo "$CHOICE" | grep -oP '\d{4}-\d{2}-\d{2} \d{2}:\d{2}')
        DATEFIX=$(echo "$DATE" | sed 's/-//g; s/ /-/; s/://')
        SELECTED=$(ls -t "$SCREENSHOTS_DIR"/*${DATEFIX}*.png 2>/dev/null | head -1)

        if [[ -f "$SELECTED" ]]; then
            ACTION=$(printf '󰆏  Copy to Clipboard\n󰏌  Open\n󰩹  Delete' | rofi -dmenu \
                -p "$(basename "$SELECTED")" \
                -theme "$MENU_THEME" \
                -theme-str "listview { lines: 3; }" \
                2>/dev/null)

            case "$ACTION" in
                *"Copy"*)
                    wl-copy < "$SELECTED"
                    notify-send "Screenshot" "Copied to clipboard"
                    ;;
                *"Open"*)
                    xdg-open "$SELECTED" &
                    ;;
                *"Delete"*)
                    rm -f "$SELECTED"
                    rm -f "$CACHE_DIR/$(basename "$SELECTED" .png)_thumb.png"
                    notify-send "Screenshot" "Deleted"
                    ;;
            esac
        fi
        ;;
esac
