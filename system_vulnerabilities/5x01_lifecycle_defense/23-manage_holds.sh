#!/bin/bash

LOG="/var/log/package_holds.log"
ACTION="$1"

case "$ACTION" in
    list)
        echo "=== Package Hold Registry ==="
        echo ""
        held_packages=$(apt-mark showhold 2>/dev/null)
        printf "%-16s %-12s %-12s %-5s %s\n" "Package" "Version" "Held Since" "Days" "Reason"

        total=0
        old=0
        if [ -f "$LOG" ]; then
            while IFS='|' read -r timestamp pkg version reason; do
                timestamp=$(echo "$timestamp" | xargs)
                pkg=$(echo "$pkg" | xargs)
                version=$(echo "$version" | xargs)
                reason=$(echo "$reason" | xargs)
                held_date=$(echo "$timestamp" | awk '{print $1}')
                days=$(( ( $(date +%s) - $(date -d "$held_date" +%s) ) / 86400 ))
                printf "%-16s %-12s %-12s %-5s %s\n" "$pkg" "$version" "$held_date" "$days" "$reason"
                total=$((total + 1))
                if [ "$days" -gt 14 ]; then
                    old=$((old + 1))
                fi
            done < "$LOG"
        fi
        echo ""
        echo "Total holds: $total"
        echo "Holds older than 14 days: $old"
        ;;
    release)
        if [ -z "$2" ]; then
            echo "Usage: $0 release <package>"
            exit 1
        fi
        echo "Releasing hold on $2..."
        sudo apt-mark unhold "$2" >/dev/null 2>&1
        echo "  apt-mark unhold $2: Done"
        sudo sed -i "/| $2 |/d" "$LOG" 2>/dev/null
        echo "  Removed from $LOG"
        echo ""
        echo "Package will be upgraded on next automatic cycle."
        ;;
    *)
        echo "Usage: $0 {list|release <package>}"
        exit 1
        ;;
esac
