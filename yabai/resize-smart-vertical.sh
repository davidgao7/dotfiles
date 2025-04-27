#!/bin/bash

DIRECTION="$1" # "up" or "down"
STEP=${2:-20}
YABAI="/opt/homebrew/bin/yabai" # (adjust if necessary)

if [[ "$DIRECTION" == "up" ]]; then
    has_neighbor=$($YABAI -m query --windows --window | jq '.["has-top"]')
    if [[ "$has_neighbor" == "true" ]]; then
        $YABAI -m window --resize top:0:-$STEP
    else
        $YABAI -m window --resize bottom:0:-$STEP
    fi
elif [[ "$DIRECTION" == "down" ]]; then
    has_neighbor=$($YABAI -m query --windows --window | jq '.["has-bottom"]')
    if [[ "$has_neighbor" == "true" ]]; then
        $YABAI -m window --resize bottom:0:$STEP
    else
        $YABAI -m window --resize top:0:$STEP
    fi
else
    echo "Usage: up|down step"
    exit 1
fi
