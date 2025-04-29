#!/bin/sh

sketchybar --add item wifi right \
    --set wifi \
    icon=󰖩 \
    script="$PLUGIN_DIR/wifi.sh" \
    update_freq=1500
