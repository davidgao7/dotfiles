#!/bin/bash

plist_data=$(defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources 2>/dev/null)

layout_name=$(echo "$plist_data" | grep '"KeyboardLayout Name"' | head -n1 | cut -d '"' -f4)
input_mode=$(echo "$plist_data" | grep '"Input Mode"' | head -n1 | cut -d '"' -f4)

label=""
icon=""

# First prioritize layout_name if exists
if [ -n "$layout_name" ]; then
    case "$layout_name" in
    "U.S.")
        label="EN"
        icon="􀂕"
        ;;
    "USInternational-PC")
        label="PC"
        icon="􀂕"
        ;;
    *)
        label="?"
        icon="􀍶"
        ;;
    esac
fi

# If no layout_name matched, fallback to input_mode
if [ -n "$input_mode" ]; then
    case "$input_mode" in
    "com.apple.inputmethod.TCIM.Pinyin")
        label="繁"
        icon="􀅈"
        ;;
    "com.apple.inputmethod.SCIM.ITABC")
        label="简"
        icon="􀅈"
        ;;
    *)
        label="拼"
        icon="􀍶"
        ;;
    esac
fi

sketchybar --set input_source icon="$icon" label="$label"
