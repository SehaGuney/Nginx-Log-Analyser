#!/usr/bin/env bash

# Kullanım kontrolü
if [ $# -ne 1 ] || [ ! -f "$1" ]; then
  echo "Kullanım: $0 <nginx_access_log>"
  exit 1
fi

LOG="$1"

echo -e "\nTop 5 IP addresses with the most requests:"
awk '{print $1}' "$LOG" \
  | sort \
  | uniq -c \
  | sort -nr \
  | head -n5 \
  | awk '{print $2 " - " $1 " requests"}'

echo -e "\nTop 5 most requested paths:"
awk '{print $7}' "$LOG" \
  | sort \
  | uniq -c \
  | sort -nr \
  | head -n5 \
  | awk '{print $2 " - " $1 " requests"}'

echo -e "\nTop 5 response status codes:"
awk '{print $9}' "$LOG" \
  | sort \
  | uniq -c \
  | sort -nr \
  | head -n5 \
  | awk '{print $2 " - " $1 " requests"}'

echo -e "\nTop 5 user agents:"
# Combined log’da User‑Agent, çift tırnaklar arasında 6. alan
awk -F'"' '{print $6}' "$LOG" \
  | sort \
  | uniq -c \
  | sort -nr \
  | head -n5 \
  | sed 's/^[[:space:]]*//' \
  | awk '{ ua=""; $1=""; for(i=2;i<=NF;i++) ua=ua $i " "; print ua " - " $1+0 " requests" }'

echo
