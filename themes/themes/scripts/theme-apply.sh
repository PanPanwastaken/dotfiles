#!/usr/bin/env bash
#
# theme-apply.sh - Universal Hyprland Theme Switcher
# Usage: theme-apply.sh <theme-name>
#

set -e

THEMES_DIR="$HOME/themes"
CURRENT_THEME_FILE="$THEMES_DIR/.current"

# Config locations
HYPRLAND_THEME_CONF="$HOME/.config/hypr/theme.conf"
KITTY_THEME_CONF="$HOME/.config/kitty/theme.conf"
KITTY_HOMESCREEN_CONF="$HOME/.config/kitty/homescreen-theme.conf"
CAVA_CONF="$HOME/.config/cava/config"
PLAYER_THEME_CONF="$HOME/.config/panscripts/player-theme.conf"
P10K_CONF="$HOME/.p10k.zsh"
MICRO_SETTINGS="$HOME/.config/micro/settings.json"
WAYBAR_THEME_CSS="$HOME/.config/waybar/theme.css"
ROFI_COLORS="$HOME/.config/rofi/colors/current.rasi"
GTK3_SETTINGS="$HOME/.config/gtk-3.0/settings.ini"
GTK4_SETTINGS="$HOME/.config/gtk-4.0/settings.ini"
BTOP_THEME_DIR="$HOME/.config/btop/themes"
BTOP_CONF="$HOME/.config/btop/btop.conf"
QUTE_CONFIG="$HOME/.config/qutebrowser/config.py"
MAKO_NOTIF_THEME="$HOME/.config/mako/scripts/notif-menu.rasi"
YAZI_THEME_CONF="$HOME/.config/yazi/theme.toml"

die() {
    echo "ERROR: $1" >&2
    exit 1
}

log() {
    echo "[theme] $1"
}

# Validate theme exists
validate_theme() {
    local theme="$1"
    local theme_dir="$THEMES_DIR/$theme"

    [[ -d "$theme_dir" ]] || die "Theme '$theme' not found at $theme_dir"
    [[ -f "$theme_dir/theme.conf" ]] || die "theme.conf missing in $theme_dir"
}

# Apply Hyprland colors
apply_hyprland() {
    local theme_dir="$1"
    local hypr_theme="$theme_dir/hyprland.conf"

    if [[ -f "$hypr_theme" ]]; then
        log "Applying Hyprland theme..."
        cp "$hypr_theme" "$HYPRLAND_THEME_CONF"
    fi
}

# Apply Kitty colors
apply_kitty() {
    local theme_dir="$1"
    local kitty_theme="$theme_dir/kitty.conf"
    local homescreen_theme="$theme_dir/homescreen.conf"

    if [[ -f "$kitty_theme" ]]; then
        log "Applying Kitty theme..."
        cp "$kitty_theme" "$KITTY_THEME_CONF"
    fi

    if [[ -f "$homescreen_theme" ]]; then
        log "Applying homescreen theme..."
        cp "$homescreen_theme" "$KITTY_HOMESCREEN_CONF"
    fi
}

# Apply Waybar CSS variables
apply_waybar() {
    local theme_dir="$1"
    local waybar_theme="$theme_dir/waybar.css"

    if [[ -f "$waybar_theme" ]]; then
        log "Applying Waybar theme..."
        cp "$waybar_theme" "$WAYBAR_THEME_CSS"
    fi
}

# Apply Cava colors
apply_cava() {
    local theme_dir="$1"
    local cava_theme="$theme_dir/cava.conf"

    if [[ -f "$cava_theme" && -f "$CAVA_CONF" ]]; then
        log "Applying Cava theme..."
        # Remove existing [color] section and append new one
        sed -i '/^\[color\]/,/^\[/{ /^\[color\]/d; /^\[/!d; }' "$CAVA_CONF"
        cat "$cava_theme" >> "$CAVA_CONF"
    fi
}

# Apply player colors
apply_player() {
    local theme_dir="$1"
    local player_theme="$theme_dir/player.conf"

    if [[ -f "$player_theme" ]]; then
        log "Applying player theme..."
        cp "$player_theme" "$PLAYER_THEME_CONF"
    fi
}

# Apply Micro colorscheme
apply_micro() {
    local theme_dir="$1"
    local micro_theme="$theme_dir/micro.conf"

    if [[ -f "$micro_theme" && -f "$MICRO_SETTINGS" ]]; then
        log "Applying Micro theme..."
        source "$micro_theme"
        sed -i "s/\"colorscheme\": \"[^\"]*\"/\"colorscheme\": \"$MICRO_COLORSCHEME\"/" "$MICRO_SETTINGS"
    fi
}

# Apply Powerlevel10k colors
apply_p10k() {
    local theme_dir="$1"
    local p10k_theme="$theme_dir/p10k.conf"

    if [[ -f "$p10k_theme" && -f "$P10K_CONF" ]]; then
        log "Applying p10k theme..."
        source "$p10k_theme"

        # Update color definitions in p10k.zsh
        sed -i "s/^PINK='[^']*'/PINK='$PINK'/" "$P10K_CONF"
        sed -i "s/^PINK_SOFT='[^']*'/PINK_SOFT='$PINK_SOFT'/" "$P10K_CONF"
        sed -i "s/^BLUE='[^']*'/BLUE='$BLUE'/" "$P10K_CONF"
        sed -i "s/^BLUE_SOFT='[^']*'/BLUE_SOFT='$BLUE_SOFT'/" "$P10K_CONF"
        sed -i "s/^DARK_PINK='[^']*'/DARK_PINK='$DARK_PINK'/" "$P10K_CONF"
        sed -i "s/^WHITE='[^']*'/WHITE='$WHITE'/" "$P10K_CONF"
    fi
}

# Apply Rofi colors and style
apply_rofi() {
    local theme_dir="$1"
    local rofi_theme="$theme_dir/rofi.rasi"
    local rofi_style="$theme_dir/rofi-style.rasi"

    if [[ -f "$rofi_theme" ]]; then
        log "Applying Rofi theme..."
        cp "$rofi_theme" "$ROFI_COLORS"
    fi

    if [[ -f "$rofi_style" ]]; then
        cp "$rofi_style" "$HOME/.config/rofi/launchers/type-2/style-2.rasi"
    fi
}

# Apply Mako notification menu theme
apply_mako() {
    local theme_dir="$1"
    local notif_theme="$theme_dir/notif-menu.rasi"

    if [[ -f "$notif_theme" ]]; then
        log "Applying Mako notification theme..."
        cp "$notif_theme" "$MAKO_NOTIF_THEME"
    fi
}

# Apply btop theme
apply_btop() {
    local theme_dir="$1"
    local theme_name="$2"
    local btop_theme="$theme_dir/btop.theme"

    if [[ -f "$btop_theme" ]]; then
        log "Applying btop theme..."
        cp "$btop_theme" "$BTOP_THEME_DIR/$theme_name.theme"
        # Update btop.conf to use this theme
        if [[ -f "$BTOP_CONF" ]]; then
            sed -i "s/^color_theme = .*/color_theme = \"$theme_name\"/" "$BTOP_CONF"
        fi
    fi
}

# Apply GTK theme
apply_gtk() {
    local theme_dir="$1"
    local gtk_conf="$theme_dir/gtk.conf"

    if [[ -f "$gtk_conf" ]]; then
        log "Applying GTK theme..."
        source "$gtk_conf"

        for settings_file in "$GTK3_SETTINGS" "$GTK4_SETTINGS"; do
            if [[ -f "$settings_file" ]]; then
                if [[ -n "$GTK_THEME_NAME" ]]; then
                    sed -i "s/^gtk-theme-name=.*/gtk-theme-name=$GTK_THEME_NAME/" "$settings_file"
                fi
                if [[ -n "$GTK_ICON_THEME" ]]; then
                    sed -i "s/^gtk-icon-theme-name=.*/gtk-icon-theme-name=$GTK_ICON_THEME/" "$settings_file"
                fi
            fi
        done
    fi
}

# Apply qutebrowser theme
apply_qutebrowser() {
    local theme_dir="$1"
    local qute_theme="$theme_dir/qutebrowser.conf"

    if [[ -f "$qute_theme" && -f "$QUTE_CONFIG" ]]; then
        log "Applying qutebrowser theme..."
        source "$qute_theme"

        # Update color variables in config.py
        sed -i "s/^pink = '[^']*'/pink = '$QUTE_PINK'/" "$QUTE_CONFIG"
        sed -i "s/^blue = '[^']*'/blue = '$QUTE_BLUE'/" "$QUTE_CONFIG"
        sed -i "s/^bg_dark = '[^']*'/bg_dark = '$QUTE_BG_DARK'/" "$QUTE_CONFIG"
        sed -i "s/^bg_darker = '[^']*'/bg_darker = '$QUTE_BG_DARKER'/" "$QUTE_CONFIG"
        sed -i "s/^bg_light = '[^']*'/bg_light = '$QUTE_BG_LIGHT'/" "$QUTE_CONFIG"
        sed -i "s/^fg = '[^']*'/fg = '$QUTE_FG'/" "$QUTE_CONFIG"
        sed -i "s/^fg_dim = '[^']*'/fg_dim = '$QUTE_FG_DIM'/" "$QUTE_CONFIG"

        # Update hint border color
        sed -i "s/c.hints.border = '[^']*'/c.hints.border = '1px solid $QUTE_PINK'/" "$QUTE_CONFIG"

        # Switch stylesheet
        sed -i "s|\"~/.config/qutebrowser/css/[^\"]*-sites.css\"|\"~/.config/qutebrowser/css/$QUTE_STYLESHEET\"|" "$QUTE_CONFIG"
    fi
}

# Apply Yazi theme
apply_yazi() {
    local theme_dir="$1"
    local yazi_theme="$theme_dir/yazi.toml"

    if [[ -f "$yazi_theme" ]]; then
        log "Applying Yazi theme..."
        mkdir -p "$(dirname "$YAZI_THEME_CONF")"
        cp "$yazi_theme" "$YAZI_THEME_CONF"
    fi
}

# Apply wallpaper
apply_wallpaper() {
    local theme_dir="$1"
    source "$theme_dir/theme.conf"

    if [[ -n "$WALLPAPER" ]]; then
        local wp_path
        if [[ "$WALLPAPER" = /* ]]; then
            wp_path="$WALLPAPER"
        else
            wp_path="$theme_dir/$WALLPAPER"
        fi

        if [[ -f "$wp_path" ]]; then
            log "Setting wallpaper..."
            # Clear dim cache so new wallpaper gets fresh processing
            rm -rf /tmp/homescreen_dim_cache/* 2>/dev/null || true
            swww img "$wp_path" --transition-type fade --transition-duration 1
        fi
    fi
}

# Reload applications
reload_apps() {
    log "Reloading applications..."

    # Hyprland - reload config
    hyprctl reload 2>/dev/null || true

    # Kitty - send SIGUSR1 to reload config
    pkill -SIGUSR1 kitty 2>/dev/null || true

    # Waybar - restart
    pkill waybar 2>/dev/null || true
    sleep 0.3
    waybar &disown 2>/dev/null

    # Qutebrowser - reload config and stylesheet via IPC
    if pgrep -x qutebrowser >/dev/null 2>&1; then
        qutebrowser ':config-source' ':reload' 2>/dev/null &disown || true
    fi

    log "Note: Restart btop/GTK apps to see theme changes"
}

# Save current theme
save_current() {
    local theme="$1"
    echo "$theme" > "$CURRENT_THEME_FILE"
}

# Get current theme
get_current() {
    if [[ -f "$CURRENT_THEME_FILE" ]]; then
        cat "$CURRENT_THEME_FILE"
    else
        echo "none"
    fi
}

# List available themes
list_themes() {
    echo "Available themes:"
    for d in "$THEMES_DIR"/*/; do
        if [[ -d "$d" && -f "$d/theme.conf" ]]; then
            local name=$(basename "$d")
            source "$d/theme.conf"
            echo "  $name - ${THEME_DESCRIPTION:-No description}"
        fi
    done
}

# Main
main() {
    local theme="$1"

    if [[ -z "$theme" ]]; then
        echo "Usage: theme-apply.sh <theme-name>"
        list_themes
        exit 0
    fi

    validate_theme "$theme"

    local theme_dir="$THEMES_DIR/$theme"

    log "Applying theme: $theme"

    apply_hyprland "$theme_dir"
    apply_kitty "$theme_dir"
    apply_waybar "$theme_dir"
    apply_rofi "$theme_dir"
    apply_mako "$theme_dir"
    apply_btop "$theme_dir" "$theme"
    apply_gtk "$theme_dir"
    apply_cava "$theme_dir"
    apply_player "$theme_dir"
    apply_p10k "$theme_dir"
    apply_micro "$theme_dir"
    apply_qutebrowser "$theme_dir"
    apply_yazi "$theme_dir"
    apply_wallpaper "$theme_dir"

    reload_apps
    save_current "$theme"

    log "Theme '$theme' applied successfully!"
    notify-send "Theme Switcher" "Applied theme: $theme" -i preferences-desktop-theme 2>/dev/null || true
}

main "$@"
