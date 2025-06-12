#!/bin/bash

if scutil --nwi | grep -qE '^\s*(utun|ipsec|ppp|pppoe|vpn)[0-9]*'; then
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
