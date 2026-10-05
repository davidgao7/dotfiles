#!/usr/bin/env bash
# waybar "custom/cpu" — replaces the built-in cpu module, which cannot report
# temperature (no {temperature} placeholder, no tooltip-format in waybar 0.15).
#
#   text    : overall CPU usage  ("<icon>  NN%")
#   tooltip : CPU temperature (k10temp Tctl/Tccd) + per-core usage
#
# Per-core usage needs a delta between two /proc/stat samples, so the previous
# snapshot is kept in a run-state file under the first writable directory.

set -uo pipefail

ICON=$'\uf2db'                                        # nf-fa-microchip, matches the old format

# Probe by actually creating a file: a -w test can lie under a read-only mount.
STATE=""
for dir in "${XDG_RUNTIME_DIR:-}" /tmp "${HOME:-}/.cache"; do
    [ -n "$dir" ] && [ -d "$dir" ] || continue
    if : 2>/dev/null >"$dir/.waybar-cpu-probe.$$"; then
        rm -f "$dir/.waybar-cpu-probe.$$"
        STATE="$dir/waybar-cpu-$(id -u).state"
        break
    fi
done

# One line per CPU ("<total_jiffies> <idle_jiffies>"), aggregate first:
# index 0 = "cpu", indices 1..N = cpu0..cpuN-1.
snapshot() {
    local name rest total idle v
    while read -r name rest; do
        set -- $rest
        total=0
        for v in "$@"; do total=$((total + v)); done
        idle=$(( $4 + $5 ))                           # idle + iowait
        printf '%s %s\n' "$total" "$idle"
    done < <(grep -E '^cpu[0-9]* ' /proc/stat)
}

# usage % between two "<total> <idle>" pairs, rounded to nearest integer
pct() {
    local dt=$(( $3 - $1 )) di=$(( $4 - $2 ))
    if [ "$dt" -le 0 ]; then echo 0; return; fi
    echo $(( (200 * (dt - di) + dt) / (2 * dt) ))
}

cur=$(snapshot)
prev=""
[ -n "$STATE" ] && [ -r "$STATE" ] && prev=$(cat "$STATE" 2>/dev/null)
if [ -z "$prev" ]; then                               # first tick: need a delta, so take a fast second sample
    sleep 0.2
    prev=$cur
    cur=$(snapshot)
fi
[ -n "$STATE" ] && printf '%s\n' "$cur" >"$STATE" 2>/dev/null

mapfile -t cur_lines  <<<"$cur"
mapfile -t prev_lines <<<"$prev"

read -r pt pi <<<"${prev_lines[0]}"
read -r ct ci <<<"${cur_lines[0]}"
overall=$(pct "$pt" "$pi" "$ct" "$ci")

# ── temperature: locate k10temp by hwmon name (hwmon numbers are not stable) ──
temp_block=""
for hw in /sys/class/hwmon/hwmon*; do
    [ "$(cat "$hw/name" 2>/dev/null)" = "k10temp" ] || continue
    for input in "$hw"/temp*_input; do
        [ -r "$input" ] || continue
        label=$(cat "${input%_input}_label" 2>/dev/null)
        milli=$(cat "$input" 2>/dev/null) || continue
        [ -n "$milli" ] || continue
        # bash has no float math: format the millidegrees into °C by hand
        celsius=$(( milli / 100 ))
        temp_block+="${label:-temp}: ${celsius%?}.${celsius: -1}°C"$'\n'
    done
done

# ── per-core usage ──
core_block=""
for (( i = 1; i < ${#cur_lines[@]}; i++ )); do
    [ -n "${prev_lines[i]:-}" ] || continue
    read -r p0 p1 <<<"${prev_lines[i]}"
    read -r c0 c1 <<<"${cur_lines[i]}"
    core_block+="Cpu$(( i - 1 )): $(pct "$p0" "$p1" "$c0" "$c1")%"$'\n'
done

tooltip="${temp_block}
${core_block%$'\n'}"

jq -c -n --arg text "$ICON  ${overall}%" --arg tooltip "$tooltip" \
    --arg class "cpu" '{text: $text, tooltip: $tooltip, class: $class}'
