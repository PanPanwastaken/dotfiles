#!/bin/bash

# Unified launcher

mode=$(echo -e "󰀻 Apps\n YouTube\n Google\n GitHub\n Arch Wiki\n Reddit\n󰏖 Package\n󰏖 AUR" | rofi -dmenu -p "󰍉" -theme ~/.config/mako/scripts/notif-menu.rasi)

[ -z "$mode" ] && exit 0

get_query() {
    echo "" | rofi -dmenu -p "$1" -theme ~/.config/mako/scripts/notif-menu.rasi
}

case "$mode" in
    "󰀻 Apps")
        ~/.config/rofi/launchers/type-2/launcher.sh
        ;;
    *"YouTube"*)
        query=$(get_query "YouTube")
        [ -n "$query" ] && qutebrowser "https://www.youtube.com/results?search_query=$(echo $query | sed 's/ /+/g')"
        ;;
    *"Google"*)
        query=$(get_query "Google")
        [ -n "$query" ] && qutebrowser "https://www.google.com/search?q=$(echo $query | sed 's/ /+/g')"
        ;;
    *"GitHub"*)
        query=$(get_query "GitHub")
        [ -n "$query" ] && qutebrowser "https://github.com/search?q=$(echo $query | sed 's/ /+/g')"
        ;;
    *"Arch Wiki"*)
        query=$(get_query "Arch Wiki")
        [ -n "$query" ] && qutebrowser "https://wiki.archlinux.org/index.php?search=$(echo $query | sed 's/ /+/g')"
        ;;
    *"Reddit"*)
        query=$(get_query "Reddit")
        [ -n "$query" ] && qutebrowser "https://www.reddit.com/search/?q=$(echo $query | sed 's/ /+/g')"
        ;;
    *"Package"*)
        query=$(get_query "Package")
        [ -z "$query" ] && exit 0
        pkg=$(pacman -Ss "$query" 2>/dev/null | grep -E "^[a-z]" | rofi -dmenu -p "󰏖" -theme ~/.config/mako/scripts/notif-menu.rasi | awk '{print $1}' | cut -d'/' -f2)
        [ -n "$pkg" ] && kitty -e sudo pacman -S "$pkg"
        ;;
    *"AUR"*)
        query=$(get_query "AUR")
        [ -z "$query" ] && exit 0
        pkg=$(yay -Ss "$query" 2>/dev/null | grep -E "^[a-z]" | rofi -dmenu -p "󰏖" -theme ~/.config/mako/scripts/notif-menu.rasi | awk '{print $1}' | cut -d'/' -f2)
        [ -n "$pkg" ] && kitty -e yay -S "$pkg"
        ;;
esac
