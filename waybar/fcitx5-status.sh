#!/bin/bash

current_im=$(fcitx5-remote -n 2>/dev/null)

case "$current_im" in
    "keyboard-us"|"keyboard-"*)
        echo '{"text": "EN", "tooltip": "English", "class": "english"}'
        ;;
    "rime"|"luna-pinyin"|"luna-pinyin-simp"|"pinyin"|"shuangpin"|"wubi"*)
        echo '{"text": "中", "tooltip": "Rime 中文", "class": "rime"}'
        ;;
    *)
        echo "{\"text\":\"?\", \"tooltip\": \"$current_im\", \"class\": \"unknown\"}"
        ;;
esac
