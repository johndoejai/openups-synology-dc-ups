#!/bin/sh
# OpenUPS NUT full-dump logger (DSM upsc without -j)
# Writes one JSON object per line (JSONL): timestamp + all upsc key/value pairs

set -eu

UPS_NAME="${1:-ups}"

LOG_DIR="${LOG_DIR:-/volume1/ups-logs}"
RETENTION_DAYS="${RETENTION_DAYS:-180}"   # set to 0 to disable cleanup
LOCK_DIR="/tmp/openups_log_all.${UPS_NAME}.lock"

# lock (avoid overlap)
if ! mkdir "$LOCK_DIR" 2>/dev/null; then
  exit 0
fi
trap 'rmdir "$LOCK_DIR" 2>/dev/null || true' EXIT INT TERM

# ensure log dir exists
if [ ! -d "$LOG_DIR" ]; then
  mkdir -p "$LOG_DIR"
fi

DAY="$(date +%F)"
LOG_FILE="${LOG_DIR}/openups_${DAY}.jsonl"
TMP_FILE="${LOG_FILE}.tmp"

ts="$(date -Iseconds)"

dump="$(upsc "$UPS_NAME" 2>/dev/null || true)"
if [ -z "$dump" ]; then
  printf '{"ts":"%s","ups":"%s","error":"upsc_failed"}\n' "$ts" "$UPS_NAME" >> "$LOG_FILE"
  exit 0
fi

printf '%s\n' "$dump" | awk -v ts="$ts" -v ups="$UPS_NAME" '
BEGIN { printf "{\"ts\":\"%s\",\"ups\":\"%s\",\"data\":{", ts, ups; first=1 }
{
  c=index($0,":"); if (c==0) next
  k=substr($0,1,c-1)
  v=substr($0,c+1); sub(/^[ \t]+/,"",v)

  gsub(/\\/,"\\\\",k); gsub(/\"/,"\\\"",k)
  gsub(/\\/,"\\\\",v); gsub(/\"/,"\\\"",v)

  if (!first) printf ","
  first=0
  printf "\"%s\":\"%s\"", k, v
}
END { print "}}"}' > "$TMP_FILE"

cat "$TMP_FILE" >> "$LOG_FILE"
rm -f "$TMP_FILE"

# optional cleanup
if [ "$RETENTION_DAYS" -gt 0 ] 2>/dev/null; then
  CLEAN_STAMP="${LOG_DIR}/.cleanup_${UPS_NAME}_${DAY}"
  if [ ! -f "$CLEAN_STAMP" ]; then
    : > "$CLEAN_STAMP"
    find "$LOG_DIR" -type f -name 'openups_*.jsonl' -mtime +"$RETENTION_DAYS" -delete 2>/dev/null || true
    find "$LOG_DIR" -type f -name '.cleanup_*' -mtime +30 -delete 2>/dev/null || true
  fi
fi
