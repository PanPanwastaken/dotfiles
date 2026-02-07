#!/bin/bash
# Weather display using wttr.in
# Astolfo theme colors: pink (#ff6eb4) and arctic blue (#7fdbff)

PINK='\033[38;2;255;110;180m'
BLUE='\033[38;2;127;219;255m'
RESET='\033[0m'

while true; do
    clear
    # Fetch weather and colorize
    weather=$(curl -s "wttr.in/Vancouver?0Fq" 2>/dev/null)

    # Apply colors: temperature/numbers in pink, text in blue
    echo -e "${BLUE}${weather}${RESET}" | sed \
        -e "s/\([0-9]\+°C\)/${PINK}\1${BLUE}/g" \
        -e "s/\([0-9]\+°F\)/${PINK}\1${BLUE}/g" \
        -e "s/\(km\/h\)/${PINK}\1${BLUE}/g" \
        -e "s/\(mph\)/${PINK}\1${BLUE}/g"

    sleep 600  # Update every 10 minutes
done
