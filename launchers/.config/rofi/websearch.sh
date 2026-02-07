#!/bin/bash

# Simple web search - just type "prefix query"

input=$(echo "" | rofi -dmenu -p "󰖟" -theme ~/.config/mako/scripts/notif-menu.rasi)

[ -z "$input" ] && exit 0

prefix="${input%% *}"
query="${input#* }"

[ "$prefix" = "$query" ] && prefix="ddg"

query_encoded=$(echo "$query" | jq -sRr @uri 2>/dev/null || echo "$query" | sed 's/ /+/g')

case "$prefix" in
    yt) qutebrowser "https://www.youtube.com/results?search_query=$query_encoded" ;;
    g) qutebrowser "https://www.google.com/search?q=$query_encoded" ;;
    gh) qutebrowser "https://github.com/search?q=$query_encoded" ;;
    r) qutebrowser "https://www.reddit.com/search/?q=$query_encoded" ;;
    w) qutebrowser "https://en.wikipedia.org/wiki/Special:Search?search=$query_encoded" ;;
    arch) qutebrowser "https://wiki.archlinux.org/index.php?search=$query_encoded" ;;
    aur) qutebrowser "https://aur.archlinux.org/packages?K=$query_encoded" ;;
    pkg) ~/.config/rofi/pkgsearch.sh pacman "$query" ;;
    yay) ~/.config/rofi/pkgsearch.sh yay "$query" ;;
    *) qutebrowser "https://duckduckgo.com/?q=$query_encoded" ;;
esac
