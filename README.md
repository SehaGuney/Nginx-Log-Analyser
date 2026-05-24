# Nginx Log Analyser

A Bash script that parses Nginx access logs and reports key traffic metrics.

## What It Does

Analyzes a given Nginx access log file and outputs the top 5 results for each of the following:

- IP addresses with the most requests
- Most requested paths
- HTTP response status codes
- User agents

## Usage

```bash
chmod +x log_analyser.sh
./log_analyser.sh logs/access.log
```

## Example Output

```
Top 5 IP addresses with the most requests:
192.168.1.1 - 120 requests
10.0.0.5 - 98 requests
...

Top 5 most requested paths:
/api/v1/users - 340 requests
/health - 210 requests
...

Top 5 response status codes:
200 - 1500 requests
404 - 230 requests
...

Top 5 user agents:
Mozilla/5.0 ... - 800 requests
...
```

## Stack

- Bash
- Standard Unix tools: `awk`, `sort`, `uniq`, `sed`

## Project Reference

Built as part of the [roadmap.sh Nginx Log Analyser project](https://roadmap.sh/projects/nginx-log-analyser).
