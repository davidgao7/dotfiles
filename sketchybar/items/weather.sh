#!/bin/sh

sketchybar --add item weather left \
    --set weather \
    icon=󰖐 \
    script="$PLUGIN_DIR/weather.sh" \
    update_freq=1500 \
    --subscribe weather mouse.clicked
