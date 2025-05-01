#!/bin/bash

INTERFACE=$(route get default | awk '/interface:/ { print $2 }')

get_bytes() {
    netstat -ibn | awk -v iface="$INTERFACE" '$1 == iface && $3 ~ /^<Link/ {rx+=$7; tx+=$10} END {print rx, tx}'
}

read initial_rx initial_tx < <(get_bytes)
sleep 1
read final_rx final_tx < <(get_bytes)

DOWN=$((final_rx - initial_rx))
UP=$((final_tx - initial_tx))

human_readable() {
    local bytes=$1
    if [ "$bytes" -ge 1073741824 ]; then
        printf "%.2f GB/s" "$(bc -l <<<"$bytes/1073741824")"
    elif [ "$bytes" -ge 1048576 ]; then
        printf "%.2f MB/s" "$(bc -l <<<"$bytes/1048576")"
    elif [ "$bytes" -ge 1024 ]; then
        printf "%.2f KB/s" "$(bc -l <<<"$bytes/1024")"
    else
        echo "$bytes B/s"
    fi
}

sketchybar --set net.down label="$(human_readable $DOWN)" \
    --set net.up label="$(human_readable $UP)"
