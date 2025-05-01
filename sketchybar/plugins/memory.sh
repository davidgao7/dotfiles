#!/bin/bash

FREE=$(memory_pressure | grep "System-wide memory free percentage:" | awk '{print $5}' | tr -d '%')
USED=$((100 - FREE))
sketchybar --set "$NAME" label="${USED}%"
