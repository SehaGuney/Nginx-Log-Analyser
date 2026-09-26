#!/usr/bin/env bash
# Nginx access log analyser: prints the top 5 IPs, paths, status codes and user agents.
set -eu

if [ $# -ne 1 ] || [ ! -f "$1" ]; then
  echo "Usage: $0 <nginx_access_log>" >&2
  exit 1
fi

LOG="$1"

# Reads values from stdin and prints the 5 most frequent as "<value> - <count> requests"
top5() {
  sort | uniq -c | sort -rn | head -n 5 |
    awk '{ count = $1; $1 = ""; sub(/^ /, ""); print $0 " - " count " requests" }'
}

echo
echo "Top 5 IP addresses with the most requests:"
awk '{ print $1 }' "$LOG" | top5

echo
echo "Top 5 most requested paths:"
awk '{ print $7 }' "$LOG" | top5

echo
echo "Top 5 response status codes:"
awk '$9 ~ /^[0-9][0-9][0-9]$/ { print $9 }' "$LOG" | top5

echo
echo "Top 5 user agents:"
awk -F'"' '{ print $6 }' "$LOG" | top5

echo
