#!/usr/bin/env bash
set -euo pipefail

APP_URL="${APP_URL:-http://localhost:3000}"
SERVICE_NAME="${SERVICE_NAME:-devops-poc-app}"

section() {
  printf '\n========== %s ==========\n' "$1"
}

run() {
  printf '\n$ %s\n' "$*"
  eval "$@" || true
}

section "1. Impact and endpoint checks"
run "date"
run "hostname"
run "curl -i -s $APP_URL/ | head -n 20"
run "curl -i -s $APP_URL/healthz"
run "curl -i -s $APP_URL/readyz"
run "curl -i -s $APP_URL/error | head -n 20"

section "2. System resources"
run "uptime"
run "free -h"
run "df -h"
run "ps aux --sort=-%cpu | head -n 8"
run "ps aux --sort=-%mem | head -n 8"

section "3. Network and ports"
run "ss -tulpn 2>/dev/null | head -n 20"
run "curl -s -o /dev/null -w 'HTTP %{http_code} in %{time_total}s\n' $APP_URL/healthz"

section "4. Docker checks"
run "docker ps 2>/dev/null | head"
run "docker logs --tail=50 $SERVICE_NAME 2>/dev/null"

section "5. Kubernetes checks"
run "kubectl get pods -A 2>/dev/null | head"
run "kubectl get all -n devops-poc 2>/dev/null"
run "kubectl logs -n devops-poc -l app=devops-poc-app --tail=50 2>/dev/null"

section "Interview answer"
cat <<'ANSWER'
When troubleshooting, I first understand impact and recent changes.
Then I check service status, logs, resources, disk, network connectivity, ports,
environment variables, permissions, and deployment state.
I avoid guessing, apply the safest fix, and document prevention steps.
ANSWER
