#!/bin/bash

# Get disk info (in kilobytes)
DISK_INFO=$(df -k / | tail -1)
USED_KB=$(echo "$DISK_INFO" | awk '{print $3}')
AVAIL_KB=$(echo "$DISK_INFO" | awk '{print $4}')
TOTAL_KB=$(echo "$DISK_INFO" | awk '{print $2}')

# Convert to human-readable GB (rounded)
USED_GB=$((USED_KB / 1024 / 1024))
AVAIL_GB=$((AVAIL_KB / 1024 / 1024))
TOTAL_GB=$((TOTAL_KB / 1024 / 1024))

# Calculate percentage
USAGE_PERCENT=$((100 * USED_KB / TOTAL_KB))

# Display: "91% • 891 GB left"
sketchybar --set "$NAME" label="${USAGE_PERCENT}% ${AVAIL_GB}GB left"
