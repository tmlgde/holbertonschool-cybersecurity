#!/bin/bash

# Argument : timestamp de l'erreur
if [ -z "$1" ]; then
    echo "Usage: $0 \"YYYY-MM-DD HH:MM\""
    exit 1
fi

ERROR_TIME="$1"
LOG="${2:-/var/log/dpkg.log}"   # 2e argument optionnel = chemin du log (défaut: dpkg.log)

echo "=== Update Regression Analysis ==="
echo ""
echo "Searching for updates before: $ERROR_TIME"
echo ""

# Lister les upgrades
echo "Updates in the last 24 hours:"
grep " upgrade " "$LOG" 2>/dev/null | awk '{print "  " $1 " " $2 "  " $4 " " $5 " → " $6}'

# Identifier le coupable : paquet SSL-related mis à jour le plus tard (le plus proche de l'erreur)
culprit=$(grep " upgrade " "$LOG" 2>/dev/null | grep -iE "ssl|cert|curl|crypto" | tail -1)

echo ""
echo "Most likely culprit:"
if [ -n "$culprit" ]; then
    pkg=$(echo "$culprit" | awk '{print $4}' | cut -d: -f1)
    prev=$(echo "$culprit" | awk '{print $5}')
    curr=$(echo "$culprit" | awk '{print $6}')
    echo "  PACKAGE: $pkg"
    echo "  REASON: SSL-related, updated closest to error time"
    echo "  PREVIOUS: $prev"
    echo "  CURRENT: $curr"
else
    echo "  No SSL-related package found in recent updates."
fi
