#!/bin/bash

VPN_STATUS=$(scutil --nwi | grep -E '^utun[0-9]')

ICON="􀲊" # VPN off
HIGHLIGHT=off

if [ -n "$VPN_STATUS" ]; then
    ICON="􀙨" # VPN on
    HIGHLIGHT=on
fi

sketchybar --set "$NAME" icon="$ICON" icon.highlight="$HIGHLIGHT"
