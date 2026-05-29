#!/usr/bin/env bash

raw_data=$(nvidia-smi --query-gpu=index,utilization.gpu,temperature.gpu --format=csv,noheader,nounits 2>/dev/null | tr -d ',')

if [ -z "$raw_data" ]; then
    exit 0
fi

bar_text=$(echo "$raw_data" | awk '{print $2}' | tr '\n' '/')
bar_text=${bar_text%/}

hover_list=$(echo "$raw_data" | awk '{print "GPU" $1 ": " $2 "% (" $3 "C)"}' | tr '\n' '\r')

jq -c -n --arg txt "$bar_text" --arg tt "$hover_list" '{text: $txt, tooltip: ($tt | gsub("\r"; "\n") | sub("\\n$"; ""))}' | tr -d '\n'
