#!/usr/bin/env bash
set -euo pipefail

LAB_DIR="/tmp/devops-poc-linux-lab"
APP_LOG="$LAB_DIR/logs/app.log"

line() {
  printf '\n============================================================\n'
  printf '%s\n' "$1"
  printf '============================================================\n'
}

pause() {
  read -p "Press ENTER to continue..."
}

line "Setting up Linux CLI practice lab in $LAB_DIR"
rm -rf "$LAB_DIR"
mkdir -p "$LAB_DIR"/{logs,configs,artifacts,tmp,scripts}
cd "$LAB_DIR"
echo "Lab directory created at: $LAB_DIR"
pause

line "Navigation and file commands"
echo "Try these commands:"
echo "  pwd                    # Show current directory"
echo "  ls -la                 # List files with details"
echo "  touch configs/app.conf # Create a file"
pause

echo "$ pwd"
pwd

echo "$ ls -la"
ls -la

echo "$ touch configs/app.conf"
touch configs/app.conf

echo "$ echo 'APP_ENV=dev' > configs/app.conf"
echo 'APP_ENV=dev' > configs/app.conf

echo "$ echo 'PORT=3000' >> configs/app.conf"
echo 'PORT=3000' >> configs/app.conf

echo "$ cat configs/app.conf"
cat configs/app.conf

echo "$ cp configs/app.conf configs/app.conf.bak"
cp configs/app.conf configs/app.conf.bak

echo "$ mv configs/app.conf.bak configs/app.backup"
mv configs/app.conf.bak configs/app.backup

echo "$ find . -name '*.conf' -o -name '*.backup'"
find . -name '*.conf' -o -name '*.backup'
pause

line "Create sample logs"
cat > "$APP_LOG" <<'LOG'
2025-07-09T10:00:00Z INFO application starting
2025-07-09T10:00:01Z INFO connected to service billing-api
2025-07-09T10:00:02Z WARN retrying request to documents-api
2025-07-09T10:00:03Z ERROR failed to call collections-api status=503
2025-07-09T10:00:04Z INFO request completed status=200 path=/healthz
2025-07-09T10:00:05Z ERROR missing environment variable SERVICE_URL
LOG
echo "Sample log file created"
pause

line "Text processing - grep, head, tail, wc"
echo "Practice filtering and viewing log files:"

echo "$ cat logs/app.log"
cat logs/app.log
pause

echo "$ head -n 2 logs/app.log"
head -n 2 logs/app.log
pause

echo "$ tail -n 2 logs/app.log"
tail -n 2 logs/app.log
pause

echo "$ grep 'ERROR' logs/app.log"
grep 'ERROR' logs/app.log
pause

echo "$ grep -i 'error' logs/app.log | wc -l"
grep -i 'error' logs/app.log | wc -l
pause

line "Text processing - awk and sed"
echo "Extract and transform data:"

echo "$ awk '{print \$3}' logs/app.log | sort | uniq -c"
awk '{print $3}' logs/app.log | sort | uniq -c
pause

echo "$ sed 's/ERROR/CRITICAL/g' logs/app.log | tail -n 2"
sed 's/ERROR/CRITICAL/g' logs/app.log | tail -n 2
pause

line "Permissions and ownership"
cat > scripts/healthcheck.sh <<'SCRIPT'
#!/usr/bin/env bash
curl -fsS http://localhost:3000/healthz >/dev/null && echo "healthy" || echo "unhealthy"
SCRIPT

echo "$ ls -l scripts/healthcheck.sh"
ls -l scripts/healthcheck.sh
pause

echo "$ chmod +x scripts/healthcheck.sh"
chmod +x scripts/healthcheck.sh

echo "$ ls -l scripts/healthcheck.sh (after chmod)"
ls -l scripts/healthcheck.sh
pause

echo "$ stat scripts/healthcheck.sh"
stat scripts/healthcheck.sh
pause

line "Disk and resource checks"
echo "$ df -h ."
df -h .
pause

echo "$ du -sh ./*"
du -sh ./*
pause

echo "$ free -h"
free -h || true
pause

echo "$ ps aux | head -n 5"
ps aux | head -n 5
pause

line "Process practice"
echo "Starting a background process..."
sleep 60 &
SLEEP_PID=$!
echo "$SLEEP_PID" > "$LAB_DIR/tmp/sleep.pid"

echo "$ ps -p $SLEEP_PID -o pid,ppid,stat,command"
ps -p $SLEEP_PID -o pid,ppid,stat,command
pause

echo "$ kill $SLEEP_PID"
kill $SLEEP_PID
sleep 1

echo "$ ps -p $SLEEP_PID -o pid,ppid,stat,command (after kill)"
ps -p $SLEEP_PID -o pid,ppid,stat,command || true
pause

line "Network practice"
echo "$ hostname"
hostname
pause

echo "$ ping -c 1 127.0.0.1"
ping -c 1 127.0.0.1
pause

echo "$ ss -tulpn | head"
ss -tulpn 2>/dev/null | head || true
pause

line "Archive practice - tar"
echo "$ tar -czf artifacts/lab-backup.tar.gz logs configs scripts"
tar -czf artifacts/lab-backup.tar.gz logs configs scripts

echo "$ ls -lh artifacts/lab-backup.tar.gz"
ls -lh artifacts/lab-backup.tar.gz
pause

echo "$ tar -tzf artifacts/lab-backup.tar.gz | head"
tar -tzf artifacts/lab-backup.tar.gz | head
pause

line "Cron syntax reminder"
cat <<'CRON'
Every day at midnight:
0 0 * * * /path/to/script.sh

Every 5 minutes:
*/5 * * * * /path/to/healthcheck.sh

Mon-Fri at 9 AM:
0 9 * * 1-5 /path/to/script.sh

Every hour:
0 * * * * /path/to/script.sh
CRON
pause

line "Lab complete!"
cat <<EOF
Commands practiced:
- pwd, ls, cd        → Navigation
- touch, cp, mv, rm  → File operations
- cat, head, tail    → View file contents
- grep               → Search text
- awk, sed           → Process/transform text
- wc                 → Count lines/words
- chmod              → Change permissions
- find               → Find files
- df, du             → Disk usage
- ps, kill           → Process management
- tar                → Archive files
- ping, ss           → Network tools

Try these next:
- Create your own scripts in scripts/
- Edit configs with nano or vi
- Chain commands with pipes (|)
- Redirect output (>, >>)
EOF
