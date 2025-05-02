#!/bin/bash

sketchybar --add event cpu.percent
sketchybar --add item cpu.percent left
sketchybar --set cpu.percent \
    label="?" \
    icon= \
    update_freq=3 \
    script="sketchybar --trigger cpu.percent"
sketchybar --subscribe cpu.percent cpu.percent
