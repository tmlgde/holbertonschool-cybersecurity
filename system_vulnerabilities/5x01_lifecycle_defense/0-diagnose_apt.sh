#!/bin/bash
echo "=== APT/DPKG Diagnostic ==="
echo ""
echo "Lock files:"
for lock in /var/lib/dpkg/lock-frontend /var/lib/dpkg/lock /var/lib/apt/lists/lock /var/cache/apt/archives/lock; do
    if [ -f "$lock" ]; then
        echo "  $lock: PRESENT (stale)"
    else
        echo "  $lock: OK"
    fi
done
echo ""
echo "Package states:"
echo "  Half-configured: $(dpkg -l | grep -c '^iF') packages"
echo "  Half-installed: $(dpkg -l | grep -c '^iU') packages"
echo "  Config-files: $(dpkg -l | grep -c '^rc') packages"
echo ""
echo "APT sources:"
valid=0
invalid=0
for src in /etc/apt/sources.list /etc/apt/sources.list.d/*; do
    if [ -f "$src" ]; then
        # un fichier source non vide et lisible est compté comme valide
        if [ -s "$src" ]; then
            valid=$((valid + 1))
        else
            invalid=$((invalid + 1))
        fi
    fi
done
echo "  Valid: $valid"
echo "  Invalid: $invalid"
echo ""
# Dernière opération APT (depuis le log history)
last_op=$(grep "Start-Date" /var/log/apt/history.log 2>/dev/null | tail -1 | cut -d' ' -f2-)
echo "Last APT operation: ${last_op:-Unknown}"
echo ""
# Cohérence DPKG via dpkg --audit
if [ -n "$(dpkg --audit 2>/dev/null)" ]; then
    echo "DPKG database: INCONSISTENT"
    echo "Action required: YES"
else
    echo "DPKG database: CONSISTENT"
    echo "Action required: NO"
fi
