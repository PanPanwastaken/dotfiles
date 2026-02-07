#!/bin/bash
# Clipboard history menu with image previews (rofi + theme-aware)

CACHE_DIR="$HOME/.cache/clipboard-thumbs"
TEMP_FILE="/tmp/clipboard_entries.txt"
MENU_THEME="$HOME/.config/panscripts/panmenu.rasi"
mkdir -p "$CACHE_DIR"

# Clear temp file
> "$TEMP_FILE"

# Build menu with image previews
build_menu() {
    local index=0
    while IFS=$'\t' read -r id content; do
        # Store original entry for later retrieval
        echo "$id	$content" >> "$TEMP_FILE"

        # Check if it's an image entry
        if [[ "$content" == "[[ binary data"* ]]; then
            # Extract image and create thumbnail
            local thumb="$CACHE_DIR/clip_${id}.png"
            if [[ ! -f "$thumb" ]]; then
                echo "$id	$content" | cliphist decode | magick - -resize 80x60^ -gravity center -extent 80x60 "$thumb" 2>/dev/null
            fi

            if [[ -f "$thumb" ]]; then
                printf "[$index] 󰋩 Image\0icon\x1f%s\n" "$thumb"
            else
                echo "[$index] 󰋩 Binary data"
            fi
        else
            # Text entry - show preview (truncated)
            local preview=$(echo "$content" | head -c 50 | tr '\n' ' ' | tr '\t' ' ')
            [[ ${#content} -gt 50 ]] && preview="${preview}..."
            echo "[$index] 󰆏 $preview"
        fi

        ((index++))
        [[ $index -ge 25 ]] && break
    done < <(cliphist list)
}

# Count entries for dynamic listview height
ENTRY_COUNT=$(cliphist list | head -25 | wc -l)
LIST_LINES=$(( ENTRY_COUNT < 15 ? ENTRY_COUNT : 15 ))
[[ $LIST_LINES -lt 1 ]] && LIST_LINES=1

# Show menu and get selection
SELECTED=$(build_menu | rofi -dmenu \
    -p " Clipboard" \
    -show-icons \
    -theme "$MENU_THEME" \
    -theme-str "listview { lines: $LIST_LINES; }" \
    2>/dev/null)

[[ -z "$SELECTED" ]] && exit 0

# Extract index from selection
INDEX=$(echo "$SELECTED" | grep -oP '\[\K\d+')

if [[ -n "$INDEX" ]]; then
    # Get the entry at that index (1-indexed for sed)
    LINE=$((INDEX + 1))
    ENTRY=$(sed -n "${LINE}p" "$TEMP_FILE")
    if [[ -n "$ENTRY" ]]; then
        if [[ "$ENTRY" == *"[[ binary data"* ]]; then
            echo "$ENTRY" | cliphist decode | wl-copy
            sleep 0.1
            wtype -M ctrl v -m ctrl
        else
            echo "$ENTRY" | cliphist decode | wtype -
        fi
    fi
fi

rm -f "$TEMP_FILE"
