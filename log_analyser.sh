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

# Fields are split on double quotes, so the parsing does not break when the
# request line itself contains spaces (e.g. malformed requests from scanners):
#   $2 = request line ("GET /path HTTP/1.1"), $3 = " status bytes ", $6 = user agent

echo
echo "Top 5 IP addresses with the most requests:"
awk '{ print $1 }' "$LOG" | top5

echo
echo "Top 5 most requested paths:"
awk -F'"' '{ if (split($2, req, " ") >= 2) print req[2] }' "$LOG" | top5

echo
echo "Top 5 response status codes:"
awk -F'"' '{ split($3, resp, " "); if (resp[1] ~ /^[0-9][0-9][0-9]$/) print resp[1] }' "$LOG" | top5

echo
echo "Top 5 user agents:"
awk -F'"' '{ print $6 }' "$LOG" | top5

echo
