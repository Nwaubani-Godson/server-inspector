#!/bin/bash

echo "===== SYSTEM SUMMARY ====="
echo "Date: $(date)"
echo "Uptime & Load: $(uptime -p), Load: $(uptime | awk -F'load average:' '{print $2}')"
echo "Logged-in Users: $(who | wc -l)"
echo "Active SSH Sessions: $(who | grep -c 'pts')"
echo ""
echo "===== MEMORY ====="
free -h
echo ""
echo "===== SWAP ====="
swapon --show || echo "Swap not enabled"
echo ""
echo "===== DISK USAGE ====="
df -h --total | grep -E '^Filesystem|total'
echo ""
echo "===== NETWORK ====="
ip -4 addr show | grep -w inet
echo ""
echo "===== SECURITY & UPDATES ====="
apt list --upgradable 2>/dev/null | grep -v Listing | wc -l | awk '{print "Packages upgradable:", $1}'
[ -f /var/run/reboot-required ] && echo "*** System restart required ***" || echo "No restart required"
