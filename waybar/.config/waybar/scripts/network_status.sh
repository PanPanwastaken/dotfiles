#!/usr/bin/env bash

if nmcli -t -f DEVICE,STATE device | grep -q '^wlan0:connected'; then
    echo "On"
else
    echo "Off"
fi
