#!/usr/bin/env bash

# Register the event that the helper listens for
sketchybar --add event cpu.percent

# Add the item
sketchybar --add item cpu.percent left

# Configure it
sketchybar --set cpu.percent \
    icon= \
    icon.font="JetBrainsMono Nerd Font:Regular:14.0" \
    icon.color=$GREEN \
    label.font="JetBrainsMono Nerd Font:Regular:13.0" \
    label.color=$LABEL_COLOR \
    update_freq=3 \
    script="sketchybar --trigger cpu.percent"

# Subscribe the item to the event
sketchybar --subscribe cpu.percent
