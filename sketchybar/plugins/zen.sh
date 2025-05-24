#!/usr/bin/env bash

ZEN_FLAG="/tmp/sketchybar_zen_mode"

HIDE_ITEMS=(
    front_app
    disk
    ram
    cpu.percent
    net.up
    net.down
    brew
    calendar
    wifi
    volume
    volume_icon
    battery
    input_source
    media
    weather
    status
    vpn
)

if [[ -f "$ZEN_FLAG" ]]; then
    # 🔓 Turn OFF Zen Mode
    rm "$ZEN_FLAG"

    for item in "${HIDE_ITEMS[@]}"; do
        sketchybar --set "$item" drawing=on
    done

    sketchybar --set zen icon="🧘" label="Zen"

else
    # 🔒 Turn ON Zen Mode
    touch "$ZEN_FLAG"

    for item in "${HIDE_ITEMS[@]}"; do
        sketchybar --set "$item" drawing=off
    done

    sketchybar --set zen icon="🌙" label="Focus"
fi
