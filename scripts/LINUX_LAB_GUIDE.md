# Linux Command Lab - Practice Guide

Follow this guide at your own pace. Type each command yourself and observe the output.

## Setup

First, create your practice lab directory:

```bash
LAB_DIR="/tmp/devops-poc-linux-lab"
rm -rf "$LAB_DIR"
mkdir -p "$LAB_DIR"/{logs,configs,artifacts,tmp,scripts}
cd "$LAB_DIR"
```

Verify you're in the right place:
```bash
pwd
```

---

## Section 1: Navigation and File Commands

### View directory contents
```bash
ls -la
```
What you should see: empty directories you just created

### Create a config file
```bash
touch configs/app.conf
```

### Add content to the file
```bash
echo 'APP_ENV=dev' > configs/app.conf
```

### Append more content (>> appends, > overwrites)
```bash
echo 'PORT=3000' >> configs/app.conf
```

### View the file contents
```bash
cat configs/app.conf
```

### Copy the file
```bash
cp configs/app.conf configs/app.conf.bak
```

### Rename/move the file
```bash
mv configs/app.conf.bak configs/app.backup
```

### Find files by name
```bash
find . -name '*.conf' -o -name '*.backup'
```
Should show both `app.conf` and `app.backup`

---

## Section 2: Working with Logs - head, tail, cat

### First, create a sample log file

Copy and paste this whole block:
```bash
cat > logs/app.log <<'LOG'
2025-07-09T10:00:00Z INFO application starting
2025-07-09T10:00:01Z INFO connected to service billing-api
2025-07-09T10:00:02Z WARN retrying request to documents-api
2025-07-09T10:00:03Z ERROR failed to call collections-api status=503
2025-07-09T10:00:04Z INFO request completed status=200 path=/healthz
2025-07-09T10:00:05Z ERROR missing environment variable SERVICE_URL
LOG
```

### View entire log file
```bash
cat logs/app.log
```

### View first 2 lines
```bash
head -n 2 logs/app.log
```

### View last 2 lines
```bash
tail -n 2 logs/app.log
```

---

## Section 3: Text Searching - grep

### Find all ERROR lines
```bash
grep 'ERROR' logs/app.log
```
Should show 2 error lines

### Count how many errors (case-insensitive)
```bash
grep -i 'error' logs/app.log | wc -l
```
Should output: `2`

### Search for a specific word
```bash
grep 'billing' logs/app.log
```

---

## Section 4: Text Processing - awk and sed

### Extract the 3rd column from each line
```bash
awk '{print $3}' logs/app.log
```
Shows: application, connected, retrying, failed, request, missing

### Extract the 3rd column, sort, count occurrences
```bash
awk '{print $3}' logs/app.log | sort | uniq -c
```

### Replace ERROR with CRITICAL and view last 2 lines
```bash
sed 's/ERROR/CRITICAL/g' logs/app.log | tail -n 2
```

### View the original file again (sed doesn't modify the file)
```bash
cat logs/app.log
```

---

## Section 5: File Permissions - chmod

### Create a simple script
```bash
cat > scripts/healthcheck.sh <<'SCRIPT'
#!/usr/bin/env bash
echo "This is a health check script"
SCRIPT
```

### View file permissions (before chmod)
```bash
ls -l scripts/healthcheck.sh
```
Notice: `-rw-rw-r--` (not executable, the `x` is missing)

### Make it executable
```bash
chmod +x scripts/healthcheck.sh
```

### View file permissions again (after chmod)
```bash
ls -l scripts/healthcheck.sh
```
Notice: `-rwxrwxr-x` (now has `x` - executable!)

### Get detailed file info
```bash
stat scripts/healthcheck.sh
```

---

## Section 6: Disk Usage - df and du

### Check disk space on current directory
```bash
df -h .
```

### Check size of each subdirectory
```bash
du -sh ./*
```

### Check system memory
```bash
free -h
```

---

## Section 7: Process Management - ps and kill

### List running processes
```bash
ps aux | head -n 5
```

### Start a background process
```bash
sleep 120 &
```
Note the PID number that appears (e.g., `[1] 12345`)

### Check that process
```bash
ps aux | grep sleep
```

### Kill the process (replace PID with the number you saw)
```bash
kill PID
```

### Check if it's gone
```bash
ps aux | grep sleep
```

---

## Section 8: Network Tools - ping and hostname

### Get your hostname
```bash
hostname
```

### Ping localhost (4 attempts)
```bash
ping -c 4 127.0.0.1
```

### Check listening ports
```bash
ss -tulpn
```

---

## Section 9: Archiving - tar

### Create a compressed backup
```bash
tar -czf artifacts/lab-backup.tar.gz logs configs scripts
```

### List contents of archive without extracting
```bash
tar -tzf artifacts/lab-backup.tar.gz
```

### Check the file size
```bash
ls -lh artifacts/lab-backup.tar.gz
```

---

## Section 10: Bonus - Piping Commands Together

### Chain multiple commands with pipes (|)

Count the number of words in the ERROR lines:
```bash
grep 'ERROR' logs/app.log | wc -w
```

Get unique status codes:
```bash
grep 'status=' logs/app.log | awk '{print $NF}' | sort | uniq
```

Find files modified in the last minute:
```bash
find . -type f -mmin -1
```

---

## Cheat Sheet

| Command | What it does |
|---------|-------------|
| `pwd` | Print working directory |
| `ls` | List files |
| `cd` | Change directory |
| `touch` | Create empty file |
| `cat` | View file contents |
| `echo` | Print text |
| `cp` | Copy file |
| `mv` | Move/rename file |
| `rm` | Remove file |
| `mkdir` | Create directory |
| `head` | First N lines |
| `tail` | Last N lines |
| `grep` | Search for text |
| `awk` | Extract/process columns |
| `sed` | Find and replace text |
| `wc` | Count lines/words/chars |
| `sort` | Sort lines |
| `uniq` | Remove duplicate lines |
| `chmod` | Change file permissions |
| `ps` | List processes |
| `kill` | Terminate process |
| `df` | Disk space usage |
| `du` | Directory size |
| `tar` | Archive files |
| `ping` | Test connectivity |
| `find` | Search for files |
| `>` | Redirect output (overwrite) |
| `>>` | Append to file |
| `\|` | Pipe (chain commands) |

---

## Tips

- Type slowly and watch what each command does
- Read the output carefully
- Don't just memorize - understand WHY each command works
- Try modifying the commands (e.g., `head -n 3` instead of `-n 2`)
- Use `man <command>` to read the manual for any command
