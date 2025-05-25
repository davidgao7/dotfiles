#!/bin/bash

VPN_STATUS=$(scutil --nwi | grep -qE 'utun[0-9]')

if scutil --nwi | grep -qE 'utun[0-9]'; then
    # VPN is up
    sketchybar --set "$NAME" \
        icon="􀙨" \
        icon.color=0xff00ff00 # green
else
    # VPN is down
    sketchybar --set "$NAME" \
        icon="􀲊" \
        icon.color=0xffffffff # white
fi
