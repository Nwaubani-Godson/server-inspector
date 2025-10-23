#!/bin/bash
# A production-safe system summary script for Ubuntu/Debian servers

# Color codes
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
NC="\033[0m" # No Color

echo -e "${YELLOW}===== UPTIME & LOAD =====${NC}"
uptime_str=$(uptime -p)
read load1 load5 load15 <<< $(uptime | awk -F'load average:' '{print $2}' | tr -d ' ' | tr ',' ' ')
echo "Uptime: $uptime_str"
echo "Load Average (1 min / 5 min / 15 min): $load1 / $load5 / $load15"


echo -e "${YELLOW}===== MEMORY =====${NC}"
echo -e "Used\tTotal\tFree"
free -h | awk '/Mem:/ {printf "%s\t%s\t%s\n", $3, $2, $4}'

echo ""
echo -e "${YELLOW}===== SWAP =====${NC}"
swap_info=$(swapon --show | awk 'NR>1 {print $1,$3,$4}') 
echo "${swap_info:-Swap not enabled}"

echo ""
echo -e "${YELLOW}===== DISK USAGE =====${NC}"
df -h --total | awk 'NR==1 || /\/$/ || /total/ {print}'

echo ""
echo -e "${YELLOW}===== NETWORK =====${NC}"
ip -4 addr show | grep -v '127.0.0.1' | grep inet

echo ""
echo -e "${YELLOW}===== SECURITY & UPDATES =====${NC}"
upgradable=$(apt list --upgradable 2>/dev/null | grep -v Listing)
echo "Packages upgradable: $(echo "$upgradable" | wc -l)"
# Uncomment below to list package names
# echo "$upgradable"

[ -f /var/run/reboot-required ] && echo -e "${RED}*** System restart required ***${NC}" || echo "No restart required"

echo -e "${GREEN}===== END OF SUMMARY =====${NC}"
