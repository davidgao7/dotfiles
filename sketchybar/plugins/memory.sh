#!/bin/bash

MEMORY_STATS=$(vm_stat)
PAGE_SIZE=$(sysctl -n hw.pagesize)

PAGES_FREE=$(echo "$MEMORY_STATS" | awk '/Pages free/ {print $3}' | sed 's/\.//')
PAGES_ACTIVE=$(echo "$MEMORY_STATS" | awk '/Pages active/ {print $3}' | sed 's/\.//')
PAGES_INACTIVE=$(echo "$MEMORY_STATS" | awk '/Pages inactive/ {print $3}' | sed 's/\.//')
PAGES_WIRED=$(echo "$MEMORY_STATS" | awk '/Pages wired down/ {print $4}' | sed 's/\.//')
PAGES_COMPRESSED=$(echo "$MEMORY_STATS" | awk '/Pages occupied by compressor/ {print $5}' | sed 's/\.//')

USED=$((PAGES_ACTIVE + PAGES_INACTIVE + PAGES_WIRED + PAGES_COMPRESSED))
TOTAL=$((USED + PAGES_FREE))

MEM_PERCENT=$(echo "$USED $TOTAL" | awk '{printf "%.0f", ($1 / $2) * 100}')
MEM_PERCENT=${MEM_PERCENT:-0}

sketchybar --set memory.percent label="${MEM_PERCENT}%"
sketchybar --push memory.used value "$MEM_PERCENT"
