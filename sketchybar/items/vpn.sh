#!/bin/bash

sketchybar --add item vpn left \
    --set vpn icon=􀲊 \
    icon.font="sketchybar-app-font:Regular:14.0" \
    label="VPN" \
    padding_left=5 \
    padding_right=5 \
    update_freq=10 \
    script="$PLUGIN_DIR/vpn.sh"
