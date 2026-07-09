#!/usr/bin/env bash
set -euo pipefail

LAB_DIR="/tmp/cgi-devops-linux-lab"
APP_LOG="$LAB_DIR/logs/app.log"

line() {
  printf '\n============================================================\n'
  printf '%s\n' "$1"
  printf '============================================================\n'
}

run() {
  printf '\n$ %s\n' "$*"
  eval "$@"
}

line "Creating safe Linux CLI practice lab in $LAB_DIR"
rm -rf "$LAB_DIR"
mkdir -p "$LAB_DIR"/{logs,configs,artifacts,tmp,scripts}
cd "$LAB_DIR"

line "Navigation and file commands"
run "pwd"
run "ls -la"
run "touch configs/app.conf"
run "echo 'APP_ENV=dev' > configs/app.conf"
run "echo 'PORT=3000' >> configs/app.conf"
run "cat configs/app.conf"
run "cp configs/app.conf configs/app.conf.bak"
run "mv configs/app.conf.bak configs/app.backup"
run "find . -name '*.conf' -o -name '*.backup'"

line "Create sample logs"
cat > "$APP_LOG" <<'LOG'
2025-07-09T10:00:00Z INFO application starting
2025-07-09T10:00:01Z INFO connected to service billing-api
2025-07-09T10:00:02Z WARN retrying request to documents-api
2025-07-09T10:00:03Z ERROR failed to call collections-api status=503
2025-07-09T10:00:04Z INFO request completed status=200 path=/healthz
2025-07-09T10:00:05Z ERROR missing environment variable SERVICE_URL
LOG

run "cat logs/app.log"
run "head -n 2 logs/app.log"
run "tail -n 2 logs/app.log"
run "grep 'ERROR' logs/app.log"
run "grep -i 'error' logs/app.log | wc -l"
run "awk '{print \$3}' logs/app.log | sort | uniq -c"
run "sed 's/ERROR/CRITICAL/g' logs/app.log | tail -n 2"

line "Permissions and ownership"
cat > scripts/healthcheck.sh <<'SCRIPT'
#!/usr/bin/env bash
curl -fsS http://localhost:3000/healthz >/dev/null && echo "healthy" || echo "unhealthy"
SCRIPT
run "ls -l scripts/healthcheck.sh"
run "chmod +x scripts/healthcheck.sh"
run "ls -l scripts/healthcheck.sh"
run "stat scripts/healthcheck.sh"

line "Disk and resource checks"
run "df -h ."
run "du -sh ./*"
run "free -h || true"
run "ps aux | head -n 5"

line "Process practice"
sleep 60 &
SLEEP_PID=$!
echo "$SLEEP_PID" > "$LAB_DIR/tmp/sleep.pid"
run "ps -p $SLEEP_PID -o pid,ppid,stat,command"
run "kill $SLEEP_PID"
sleep 1
run "ps -p $SLEEP_PID -o pid,ppid,stat,command || true"

line "Network practice"
run "hostname"
run "ping -c 1 127.0.0.1"
run "curl -I -s http://localhost:3000/healthz || true"
run "ss -tulpn 2>/dev/null | head || true"

line "Archive practice"
run "tar -czf artifacts/lab-backup.tar.gz logs configs scripts"
run "ls -lh artifacts/lab-backup.tar.gz"
run "tar -tzf artifacts/lab-backup.tar.gz | head"

line "Cron syntax reminder"
cat <<'CRON'
Every day at midnight:
0 0 * * * /path/to/script.sh

Every 5 minutes:
*/5 * * * * /path/to/healthcheck.sh
CRON

line "Lab complete"
cat <<EOF
Practice explanation:
- grep searches text.
- awk extracts/processes fields.
- sed edits/replaces text.
- df checks filesystem usage.
- du checks file/directory size.
- ps/top check processes/resources.
- chmod changes permissions.
- chown changes ownership.
- curl tests HTTP endpoints.
- ss checks listening ports.
- kill stops a process.
EOF
