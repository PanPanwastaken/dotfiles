#!/bin/bash

# Get GPU utilization and VRAM usage from nvidia-smi
if command -v nvidia-smi &>/dev/null; then
    read -r gpu_util mem_used mem_total <<< $(nvidia-smi --query-gpu=utilization.gpu,memory.used,memory.total --format=csv,noheader,nounits | tr -d ' ' | tr ',' ' ')

    if [[ -n "$gpu_util" && -n "$mem_used" && -n "$mem_total" ]]; then
        # Convert MiB to GiB
        mem_used_gib=$(awk "BEGIN {printf \"%.1f\", $mem_used/1024}")
        mem_total_gib=$(awk "BEGIN {printf \"%.1f\", $mem_total/1024}")
        echo "${gpu_util}% ${mem_used_gib}G"
    else
        echo "N/A"
    fi
else
    echo "N/A"
fi
