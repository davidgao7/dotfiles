#!/bin/sh

SSID=$(system_profiler SPAirPortDataType | awk '/Current Network Information:/ {getline; gsub(/^ +|:$/, ""); print; exit}')

sketchybar --set wifi \
    icon=󰖩 \
    icon.color=0xff58d1fc \
    label="$SSID"
