#!/bin/bash

# Web search script for hyprlauncher
# Usage: websearch.sh "prefix:query"

input="$1"
prefix="${input%%:*}"
query="${input#*:}"
query_encoded=$(echo "$query" | sed 's/ /+/g')

case "$prefix" in
    yt)
        qutebrowser "https://www.youtube.com/results?search_query=$query_encoded" ;;
    g)
        qutebrowser "https://www.google.com/search?q=$query_encoded" ;;
    gh)
        qutebrowser "https://github.com/search?q=$query_encoded" ;;
    r)
        qutebrowser "https://www.reddit.com/search/?q=$query_encoded" ;;
    w)
        qutebrowser "https://en.wikipedia.org/wiki/Special:Search?search=$query_encoded" ;;
    arch)
        qutebrowser "https://wiki.archlinux.org/index.php?search=$query_encoded" ;;
    aur)
        qutebrowser "https://aur.archlinux.org/packages?K=$query_encoded" ;;
    ddg)
        qutebrowser "https://duckduckgo.com/?q=$query_encoded" ;;
    *)
        qutebrowser "https://duckduckgo.com/?q=$query_encoded" ;;
esac
