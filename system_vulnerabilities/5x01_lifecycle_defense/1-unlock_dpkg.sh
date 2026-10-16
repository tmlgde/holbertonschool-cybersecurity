#!/bin/bash
echo "=== DPKG Unlock Procedure ==="
echo ""
echo "Checking for active package operations..."

apt_proc=$(pgrep -x apt)
dpkg_proc=$(pgrep -x dpkg)

if [ -n "$apt_proc" ]; then
    echo "  apt processes: RUNNING (PID: $apt_proc)"
else
    echo "  apt processes: None"
fi

if [ -n "$dpkg_proc" ]; then
    echo "  dpkg processes: RUNNING (PID: $dpkg_proc)"
else
    echo "  dpkg processes: None"
fi
if [ -n "$apt_proc" ] || [ -n "$dpkg_proc" ]; then
    echo ""
    echo "ERROR: Active package operations detected. Aborting."
    echo "Do not remove locks while processes are running."
    exit 1
fi
echo ""
echo "Removing stale lock files..."
for lock in /var/lib/dpkg/lock-frontend /var/lib/dpkg/lock /var/lib/apt/lists/lock /var/cache/apt/archives/lock; do
    if [ -f "$lock" ]; then
        sudo rm -f "$lock"
        echo "  $lock: Removed"
    else
        echo "  $lock: Not present"
    fi
done
echo ""
echo "Verification:"
if [ ! -f /var/lib/dpkg/lock-frontend ] && [ ! -f /var/lib/dpkg/lock ]; then
    echo "  Package operations: UNLOCKED"
    echo ""
    echo "DPKG unlocked successfully."
else
    echo "  Package operations: STILL LOCKED"
    echo ""
    echo "ERROR: Some locks could not be removed."
    exit 1
fi
