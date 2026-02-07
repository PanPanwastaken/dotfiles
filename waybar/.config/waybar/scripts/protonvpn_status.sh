#!/usr/bin/env bash

state=$(grep -a 'CONN:STATE_CHANGED' /home/panpan/.cache/Proton/VPN/logs/vpn-app.log 2>/dev/null | tail -1)

if echo "$state" | grep -q '| Connected'; then
    conn=$(nmcli -t -f NAME,TYPE connection show --active 2>/dev/null | grep ':wireguard$' | head -1 | cut -d: -f1)
    if [[ -n "$conn" ]]; then
        echo "${conn#*-}"
    else
        echo "On"
    fi
else
    echo "Off"
fi
