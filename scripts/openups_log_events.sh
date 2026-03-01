#!/bin/sh
# Log important state changes to Synology Log Center via syslog (logger)

set -eu

UPS_NAME="${1:-ups}"
STATE_DIR="${STATE_DIR:-/volume1/ups-logs/state}"
mkdir -p "$STATE_DIR"

get() { upsc "$UPS_NAME" "$1" 2>/dev/null || true; }

ts="$(date -Iseconds)"
status="$(get ups.status)"
batv="$(get battery.voltage)"
soc="$(get battery.charge)"
temp="$(get battery.temperature)"
outc="$(get output.current)"
outv="$(get output.voltage)"

last_file="${STATE_DIR}/last_${UPS_NAME}.status"
last="$(cat "$last_file" 2>/dev/null || true)"

if [ -n "$status" ] && [ "$status" != "$last" ]; then
  echo "$status" > "$last_file"
  logger -t openups "ts=${ts} ups=${UPS_NAME} status=${status} soc=${soc}% batV=${batv} temp=${temp}C out=${outv}V/${outc}A"
fi
