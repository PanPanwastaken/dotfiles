#!/usr/bin/env bash

sleep 1

# Start on homescreen
~/.config/panscripts/toggle_homescreen.sh &

#tmux_pid=$!

qutebrowser &
qb_pid=$!

sleep 1


