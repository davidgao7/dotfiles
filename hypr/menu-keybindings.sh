#!/bin/bash

# A script to display Hyprland keybindings defined in your configuration
# using walker for an interactive search menu.

# Fetch dynamic keybindings from Hyprland
#
# Also do some pre-processing:
# - Remove standard Omarchy bin path prefix
# - Remove uwsm prefix
# - Map numeric modifier key mask to a textual rendition
# - Output comma-separated values that the parser can understand
dynamic_bindings() {
    hyprctl -j binds |
        jq -r '.[] | {modmask, submap, key, keycode, description, dispatcher, arg} | "\(.modmask),\(.submap),\(.key)@\(.keycode),\(.description),\(.dispatcher),\(.arg)"' |
        sed -r \
            -e 's/null//' \
            -e 's,~/.local/share/omarchy/bin/,,' \
            -e 's,uwsm app -- ,,' \
            -e 's/@0//' \
            -e 's/,@/,code:/' \
            -e 's/^0,/,/' \
            -e 's/^1,/SHIFT,/' \
            -e 's/^4,/CTRL,/' \
            -e 's/^5,/SHIFT CTRL,/' \
            -e 's/^8,/ALT,/' \
            -e 's/^9,/SHIFT ALT,/' \
            -e 's/^12,/CTRL ALT,/' \
            -e 's/^13,/SHIFT CTRL ALT,/' \
            -e 's/^64,/SUPER,/' \
            -e 's/^65,/SUPER SHIFT,/' \
            -e 's/^68,/SUPER CTRL,/' \
            -e 's/^69,/SUPER SHIFT CTRL,/' \
            -e 's/^72,/SUPER ALT,/' \
            -e 's/,,/,GLOBAL,/' \
            -e 's/,resize,/,SUBMAP resize,/'
}

# Parse and format keybindings
#
# `awk` does the heavy lifting:
# - Set the field separator to a comma ','.
# - Joins the key combination (e.g., "SUPER + Q").
# - Joins the command that the key executes.
# - Prints everything in a nicely aligned format.
parse_bindings() {
    awk -F, '{
        mods   = $1;
        submap = $2;
        key    = $3;
        desc   = $4;
        disp   = $5;
        arg    = $6;

        # Build key combo string
        key_combo = mods " + " key;
        gsub(/^[ \t]*\+?[ \t]*/, "", key_combo);
        gsub(/[ \t]+$/, "", key_combo);

        # Add submap tag if not global
        if (submap != "") {
            key_combo = "[" submap "] " key_combo;
        }

        action = desc;
        if (action == "" && disp == "submap") {
            action = "Switch to submap: " arg;
        } else if (action == "") {
            action = disp " " arg;
        }

        if (action != "") {
            printf "%-40s → %s\n", key_combo, action;
        }
    }'
}

dynamic_bindings |
    sort -u |
    parse_bindings |
    walker --dmenu --theme keybindings -p 'Keybindings'
