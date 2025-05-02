#!/usr/bin/env bash

ZEN_FLAG="/tmp/sketchybar_zen_mode"

if [[ -f "$ZEN_FLAG" ]]; then
    # 🔓 Turn OFF Zen Mode
    rm "$ZEN_FLAG"

    sketchybar --set front_app drawing=on \
        --set network_rates drawing=on \
        --set wifi drawing=on \
        --set calendar drawing=on \
        --set brew drawing=on \
        --set media drawing=on \
        --set zen icon="🧘" label="Zen"

else
    # 🔒 Turn ON Zen Mode
    touch "$ZEN_FLAG"

    sketchybar --set front_app drawing=off \
        --set network_rates drawing=off \
        --set wifi drawing=off \
        --set calendar drawing=off \
        --set brew drawing=off \
        --set media drawing=off \
        --set zen icon="🌙" label="Focus"
fi
