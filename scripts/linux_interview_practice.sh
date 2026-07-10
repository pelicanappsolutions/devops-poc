#!/usr/bin/env bash
set -uo pipefail

LAB_DIR="/tmp/linux-interview-lab"
CHALLENGES_COMPLETED=0
TOTAL_CHALLENGES=0

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

setup_lab() {
  rm -rf "$LAB_DIR"
  mkdir -p "$LAB_DIR"/{logs,data,configs,backups,users,websites}
  cd "$LAB_DIR"

  # Create realistic log files
  cat > logs/access.log <<'EOF'
2026-07-09 08:23:45 192.168.1.100 GET /api/users 200 1234
2026-07-09 08:24:12 192.168.1.101 POST /api/login 401 567
2026-07-09 08:25:00 192.168.1.102 GET /index.html 200 5678
2026-07-09 08:26:33 192.168.1.100 DELETE /api/users/5 403 200
2026-07-09 08:27:15 192.168.1.103 GET /api/data 500 89
EOF

  cat > logs/app.log <<'EOF'
[2026-07-09 08:00:00] INFO Starting application
[2026-07-09 08:00:05] INFO Database connected
[2026-07-09 08:01:20] WARN Memory usage at 75%
[2026-07-09 08:02:10] ERROR Connection timeout to cache-server
[2026-07-09 08:03:00] INFO Cache reconnected
[2026-07-09 08:04:15] ERROR Failed to process job #4521
[2026-07-09 08:05:30] WARN High CPU usage detected
[2026-07-09 08:06:45] ERROR Database query timeout
[2026-07-09 08:07:20] INFO Backup completed successfully
EOF

  cat > logs/security.log <<'EOF'
2026-07-09 08:10:00 ALERT Failed login attempt from 10.0.0.5
2026-07-09 08:15:30 ALERT Failed login attempt from 10.0.0.6
2026-07-09 08:20:15 INFO User kali logged in
2026-07-09 08:22:45 ALERT Multiple failed login from 10.0.0.7
2026-07-09 08:25:00 INFO User admin logged in
2026-07-09 08:30:20 ALERT Unauthorized API access attempt
EOF

  # Create config files
  cat > configs/database.conf <<'EOF'
HOST=localhost
PORT=5432
USER=postgres
PASSWORD=secret123
DATABASE=production
EOF

  cat > configs/app.conf <<'EOF'
ENV=production
DEBUG=false
LOG_LEVEL=info
MAX_CONNECTIONS=100
TIMEOUT=30
EOF

  cat > configs/nginx.conf <<'EOF'
server {
  listen 80;
  server_name example.com;
  location / {
    proxy_pass http://localhost:3000;
  }
}
EOF

  # Create data files
  cat > data/users.csv <<'EOF'
id,name,email,created_date
1,Alice Johnson,alice@example.com,2026-01-15
2,Bob Smith,bob@example.com,2026-02-20
3,Charlie Brown,charlie@example.com,2026-03-10
4,Diana Prince,diana@example.com,2026-04-05
5,Eve Wilson,eve@example.com,2026-05-12
EOF

  cat > data/products.csv <<'EOF'
id,name,price,stock
101,Laptop,999.99,15
102,Mouse,25.50,150
103,Keyboard,75.00,80
104,Monitor,299.99,20
105,Headphones,149.99,45
EOF

  # Create some scripts
  cat > backups/backup.sh <<'EOF'
#!/bin/bash
echo "Creating backup..."
tar -czf backup-$(date +%Y%m%d).tar.gz /var/www/
echo "Backup complete"
EOF

  # Create user directory with files
  mkdir -p users/kali users/admin users/guest
  touch users/kali/profile.txt users/kali/settings.conf
  touch users/admin/dashboard.html users/admin/config.xml
  touch users/guest/readme.txt

  # Create website files
  cat > websites/index.html <<'EOF'
<!DOCTYPE html>
<html>
<head><title>Home</title></head>
<body><h1>Welcome</h1></body>
</html>
EOF

  cat > websites/about.html <<'EOF'
<!DOCTYPE html>
<html>
<head><title>About</title></head>
<body><h1>About Us</h1></body>
</html>
EOF

  chmod +x backups/backup.sh
}

print_banner() {
  echo -e "\n${BLUE}========================================================${NC}"
  echo -e "${BLUE}  LINUX INTERVIEW PRACTICE LAB${NC}"
  echo -e "${BLUE}  Real-time challenges for interview prep${NC}"
  echo -e "${BLUE}========================================================${NC}\n"
}

challenge_1() {
  echo -e "${YELLOW}Challenge 1: Find and count error lines${NC}"
  echo "Find all ERROR lines in logs/app.log and count them."
  echo -e "How many ERROR lines are there?\n"

  read -p "Enter your command: " cmd
  output=$(eval "$cmd" 2>/dev/null || echo "")

  if [[ "$output" == *"3"* ]]; then
    echo -e "${GREEN}✓ Correct! There are 3 ERROR lines.${NC}"
    CHALLENGES_COMPLETED=$((CHALLENGES_COMPLETED + 1))
  else
    echo -e "${RED}✗ Not quite. Try using: grep 'ERROR' logs/app.log | wc -l${NC}"
  fi
  TOTAL_CHALLENGES=$((TOTAL_CHALLENGES + 1))
}

challenge_2() {
  echo -e "\n${YELLOW}Challenge 2: View specific lines${NC}"
  echo "View only the first 3 lines of logs/access.log"
  echo -e "Show me those lines:\n"

  read -p "Enter your command: " cmd
  output=$(eval "$cmd" 2>/dev/null || echo "")

  if [[ "$output" == *"192.168.1.100"* ]] && [[ "$output" == *"192.168.1.102"* ]]; then
    echo -e "${GREEN}✓ Correct! You got the first 3 lines.${NC}"
    CHALLENGES_COMPLETED=$((CHALLENGES_COMPLETED + 1))
  else
    echo -e "${RED}✗ Try: head -n 3 logs/access.log${NC}"
  fi
  TOTAL_CHALLENGES=$((TOTAL_CHALLENGES + 1))
}

challenge_3() {
  echo -e "\n${YELLOW}Challenge 3: Find specific log entries${NC}"
  echo "Find all ALERT entries in logs/security.log"
  echo -e "How many ALERT entries are there?\n"

  read -p "Enter your command: " cmd
  output=$(eval "$cmd" 2>/dev/null || echo "")

  if [[ "$output" == *"4"* ]]; then
    echo -e "${GREEN}✓ Correct! There are 4 ALERT entries.${NC}"
    CHALLENGES_COMPLETED=$((CHALLENGES_COMPLETED + 1))
  else
    echo -e "${RED}✗ Try: grep 'ALERT' logs/security.log | wc -l${NC}"
  fi
  TOTAL_CHALLENGES=$((TOTAL_CHALLENGES + 1))
}

challenge_4() {
  echo -e "\n${YELLOW}Challenge 4: Extract and process data${NC}"
  echo "Extract the 2nd field (name) from data/users.csv"
  echo -e "Show me all names:\n"

  read -p "Enter your command: " cmd
  output=$(eval "$cmd" 2>/dev/null || echo "")

  if [[ "$output" == *"Alice"* ]] && [[ "$output" == *"Bob"* ]]; then
    echo -e "${GREEN}✓ Correct! You extracted the names using awk or cut.${NC}"
    CHALLENGES_COMPLETED=$((CHALLENGES_COMPLETED + 1))
  else
    echo -e "${RED}✗ Try: awk -F',' '{print \$2}' data/users.csv${NC}"
    echo -e "     Or: cut -d',' -f2 data/users.csv${NC}"
  fi
  TOTAL_CHALLENGES=$((TOTAL_CHALLENGES + 1))
}

challenge_5() {
  echo -e "\n${YELLOW}Challenge 5: Find files by pattern${NC}"
  echo "Find all .conf files in the entire lab directory"
  echo -e "How many .conf files are there?\n"

  read -p "Enter your command: " cmd
  output=$(eval "$cmd" 2>/dev/null || echo "")

  if [[ "$output" == *"database.conf"* ]] && [[ "$output" == *"app.conf"* ]]; then
    echo -e "${GREEN}✓ Correct! You found the .conf files.${NC}"
    CHALLENGES_COMPLETED=$((CHALLENGES_COMPLETED + 1))
  else
    echo -e "${RED}✗ Try: find . -name '*.conf'${NC}"
  fi
  TOTAL_CHALLENGES=$((TOTAL_CHALLENGES + 1))
}

challenge_6() {
  echo -e "\n${YELLOW}Challenge 6: Search and replace${NC}"
  echo "Replace 'ERROR' with 'CRITICAL' in logs/app.log (don't modify the file)"
  echo -e "Show the last 2 lines of the result:\n"

  read -p "Enter your command: " cmd
  output=$(eval "$cmd" 2>/dev/null || echo "")

  if [[ "$output" == *"CRITICAL"* ]]; then
    echo -e "${GREEN}✓ Correct! You used sed to replace text.${NC}"
    CHALLENGES_COMPLETED=$((CHALLENGES_COMPLETED + 1))
  else
    echo -e "${RED}✗ Try: sed 's/ERROR/CRITICAL/g' logs/app.log | tail -n 2${NC}"
  fi
  TOTAL_CHALLENGES=$((TOTAL_CHALLENGES + 1))
}

challenge_7() {
  echo -e "\n${YELLOW}Challenge 7: List files recursively${NC}"
  echo "List all files in the users directory recursively"
  echo -e "Show me what's in there:\n"

  read -p "Enter your command: " cmd
  output=$(eval "$cmd" 2>/dev/null || echo "")

  if [[ "$output" == *"kali"* ]] || [[ "$output" == *"admin"* ]]; then
    echo -e "${GREEN}✓ Correct! You listed the directory tree.${NC}"
    CHALLENGES_COMPLETED=$((CHALLENGES_COMPLETED + 1))
  else
    echo -e "${RED}✗ Try: find users -type f${NC}"
    echo -e "     Or: tree users (if installed)${NC}"
  fi
  TOTAL_CHALLENGES=$((TOTAL_CHALLENGES + 1))
}

challenge_8() {
  echo -e "\n${YELLOW}Challenge 8: Check file permissions${NC}"
  echo "List the permissions of backups/backup.sh"
  echo -e "Is it executable?\n"

  read -p "Enter your command: " cmd
  output=$(eval "$cmd" 2>/dev/null || echo "")

  if [[ "$output" == *"rwxr"* ]] || [[ "$output" == *"755"* ]] || [[ "$output" == *"+x"* ]]; then
    echo -e "${GREEN}✓ Correct! The backup.sh file is executable.${NC}"
    CHALLENGES_COMPLETED=$((CHALLENGES_COMPLETED + 1))
  else
    echo -e "${RED}✗ Try: ls -l backups/backup.sh${NC}"
  fi
  TOTAL_CHALLENGES=$((TOTAL_CHALLENGES + 1))
}

challenge_9() {
  echo -e "\n${YELLOW}Challenge 9: Count and filter${NC}"
  echo "Count how many files have a .log extension"
  echo -e "Total number:\n"

  read -p "Enter your command: " cmd
  output=$(eval "$cmd" 2>/dev/null || echo "")

  if [[ "$output" == *"3"* ]]; then
    echo -e "${GREEN}✓ Correct! There are 3 .log files.${NC}"
    CHALLENGES_COMPLETED=$((CHALLENGES_COMPLETED + 1))
  else
    echo -e "${RED}✗ Try: find . -name '*.log' | wc -l${NC}"
  fi
  TOTAL_CHALLENGES=$((TOTAL_CHALLENGES + 1))
}

challenge_10() {
  echo -e "\n${YELLOW}Challenge 10: Advanced - Combine commands${NC}"
  echo "Find all files modified in this session and show their sizes"
  echo -e "Use find with ls to show size and filename:\n"

  read -p "Enter your command: " cmd
  output=$(eval "$cmd" 2>/dev/null || echo "")

  if [[ "$output" == *"log"* ]] || [[ "$output" == *"conf"* ]]; then
    echo -e "${GREEN}✓ Great! You chained commands together.${NC}"
    CHALLENGES_COMPLETED=$((CHALLENGES_COMPLETED + 1))
  else
    echo -e "${RED}✗ Try: find . -type f -exec ls -lh {} \\;${NC}"
  fi
  TOTAL_CHALLENGES=$((TOTAL_CHALLENGES + 1))
}

show_results() {
  echo -e "\n${BLUE}========================================================${NC}"
  echo -e "${BLUE}  INTERVIEW PRACTICE RESULTS${NC}"
  echo -e "${BLUE}========================================================${NC}\n"

  PERCENTAGE=$((CHALLENGES_COMPLETED * 100 / TOTAL_CHALLENGES))

  if [[ $PERCENTAGE -eq 100 ]]; then
    echo -e "${GREEN}Perfect Score! ${CHALLENGES_COMPLETED}/${TOTAL_CHALLENGES} (${PERCENTAGE}%)${NC}"
    echo -e "${GREEN}You're ready for that interview! 🚀${NC}"
  elif [[ $PERCENTAGE -ge 80 ]]; then
    echo -e "${GREEN}Great job! ${CHALLENGES_COMPLETED}/${TOTAL_CHALLENGES} (${PERCENTAGE}%)${NC}"
    echo -e "${YELLOW}Review the failed challenges once more.${NC}"
  elif [[ $PERCENTAGE -ge 60 ]]; then
    echo -e "${YELLOW}Good effort! ${CHALLENGES_COMPLETED}/${TOTAL_CHALLENGES} (${PERCENTAGE}%)${NC}"
    echo -e "${YELLOW}Practice the commands you struggled with.${NC}"
  else
    echo -e "${RED}Keep practicing! ${CHALLENGES_COMPLETED}/${TOTAL_CHALLENGES} (${PERCENTAGE}%)${NC}"
    echo -e "${RED}Run this script again to retry all challenges.${NC}"
  fi

  echo -e "\n${BLUE}Lab directory: $LAB_DIR${NC}"
  echo -e "${BLUE}You can explore more in: cd $LAB_DIR${NC}\n"
}

# Main execution
print_banner
setup_lab

echo -e "Lab created at: ${BLUE}$LAB_DIR${NC}"
echo -e "You can explore the files anytime with: ${BLUE}cd $LAB_DIR${NC}\n"

read -p "Ready to start? (y/n) " REPLY
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  exit 0
fi

challenge_1
challenge_2
challenge_3
challenge_4
challenge_5
challenge_6
challenge_7
challenge_8
challenge_9
challenge_10

show_results

echo -e "\n${BLUE}Tip: You can run this script again to try all challenges again.${NC}"
echo -e "${BLUE}Or explore manually: cd $LAB_DIR && bash${NC}\n"
