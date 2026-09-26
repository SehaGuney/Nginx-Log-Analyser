# Nginx Log Analyser

A Bash script that parses an Nginx access log and reports the most common IP addresses, request paths, response status codes and user agents.

Built as part of the [roadmap.sh Nginx Log Analyser project](https://roadmap.sh/projects/nginx-log-analyser).

## Usage

```bash
chmod +x log_analyser.sh
./log_analyser.sh logs/access.log
```

The script expects a log in Nginx's default `combined` format:

```
IP - - [date] "METHOD /path HTTP/1.1" status bytes "referer" "user-agent"
```

## Example Output

Output for the sample log in `logs/access.log`:

```
Top 5 IP addresses with the most requests:
178.128.94.113 - 1087 requests
142.93.136.176 - 1087 requests
138.68.248.85 - 1087 requests
159.89.185.30 - 1086 requests
86.134.118.70 - 277 requests

Top 5 most requested paths:
/v1-health - 4560 requests
/ - 270 requests
/v1-me - 232 requests
/v1-list-workspaces - 127 requests
/v1-list-timezone-teams - 75 requests

Top 5 response status codes:
200 - 5740 requests
404 - 937 requests
304 - 621 requests
400 - 260 requests
403 - 23 requests

Top 5 user agents:
DigitalOcean Uptime Probe 0.22.0 (https://digitalocean.com) - 4347 requests
Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36 - 513 requests
Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36 - 332 requests
Custom-AsyncHttpClient - 294 requests
Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36 - 282 requests
```

## How It Works

Each report is a short pipeline built from standard Unix tools:

```
awk (extract a field) | sort | uniq -c | sort -rn | head -n 5
```

The counting part is shared by all four reports through a single `top5` function.

The request line, status code and user agent are extracted by splitting each line on double quotes instead of spaces. The sample log contains malformed requests from scanners (for example TLS and RDP probes) whose request line includes spaces. Splitting on spaces shifts the fields for these lines, so a response size such as `166` would be counted as a status code. Splitting on quotes keeps the fields in place.

## Stack

- Bash
- awk, sort, uniq, head
