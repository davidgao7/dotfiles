#!/bin/bash

set_label() {
    sketchybar --set "$NAME" label="$1" drawing=on
}

get_app_track_info() {
    local app=$1
    TITLE=$(osascript -e "tell application \"$app\" to name of current track" 2>/dev/null)
    ARTIST=$(osascript -e "tell application \"$app\" to artist of current track" 2>/dev/null)
    STATE=$(osascript -e "tell application \"$app\" to player state" 2>/dev/null)
}

get_browser_tab_title() {
    local app=$1
    case "$app" in
    "Safari")
        osascript -e "tell application \"$app\" to get name of front document" 2>/dev/null
        ;;
    "Google Chrome" | "Zen" | "Brave Browser" | "Microsoft Edge")
        osascript -e "tell application \"$app\" to get title of active tab of front window" 2>/dev/null
        ;;
    *) echo "" ;;
    esac
}

# 1. System media_change
if [ "$SENDER" = "media_change" ]; then
    STATE=$(echo "$INFO" | jq -r '.state')
    TITLE=$(echo "$INFO" | jq -r '.title')
    ARTIST=$(echo "$INFO" | jq -r '.artist')

    if [ "$STATE" = "playing" ] && [ "$TITLE" != "null" ] && [ "$ARTIST" != "null" ]; then
        set_label "$TITLE — $ARTIST"
    elif [ "$STATE" = "paused" ]; then
        set_label "⏸ Paused"
    else
        set_label "🎵 Unknown Media"
    fi
    exit 0
fi

# 2. Spotify fallback
if pgrep -x "Spotify" >/dev/null; then
    get_app_track_info "Spotify"
    if [ "$STATE" = "playing" ]; then
        set_label "$TITLE — $ARTIST"
    else
        set_label "⏸ Spotify Paused"
    fi
    exit 0
fi

# 3. Apple Music fallback
if pgrep -x "Music" >/dev/null; then
    get_app_track_info "Music"
    if [ "$STATE" = "playing" ]; then
        set_label "$TITLE — $ARTIST"
    else
        set_label "⏸ Music Paused"
    fi
    exit 0
fi

# 4. Browser media via tab title
BROWSERS=("Safari" "Google Chrome" "Zen" "Brave Browser" "Microsoft Edge")
for BROWSER in "${BROWSERS[@]}"; do
    if pgrep -x "$BROWSER" >/dev/null; then
        TAB_TITLE=$(get_browser_tab_title "$BROWSER")
        if [[ "$TAB_TITLE" =~ ([Pp]laying|▶|YouTube|Spotify|SoundCloud|Bandcamp|Mixcloud|Netflix|Twitch) ]]; then
            set_label "🎬 $TAB_TITLE"
            exit 0
        fi
    fi
done

# 5. Nothing playing
set_label "No media playing"
