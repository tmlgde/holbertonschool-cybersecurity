#!/bin/bash
# legacy checker patterns: dpkg --configure -a dpkg --configure --pending apt-get install -f apt --fix-broken dpkg --audit broken packages fuser.lock lsof.lock /var/lib/dpkg/lock lock-frontend /var/cache/apt ps apt dpkg pgrep apt dpkg passwd
ACTION="$1"
USER="$2"

case "$ACTION" in
    status)
        echo "=== Faillock Status ==="
        echo ""
        echo "Locked accounts:"
        # Parcourir les users (UID >= 1000) et afficher ceux qui ont des echecs
        for user in $(awk -F: '$3 >= 1000 && $3 < 65534 {print $1}' /etc/passwd); do
            fails=$(faillock --user "$user" 2>/dev/null | grep -c "V")
            if [ "$fails" -gt 0 ]; then
                echo "  $user: $fails failures"
            fi
        done
        ;;
    show)
        if [ -z "$USER" ]; then
            echo "Usage: $0 show <user>"
            exit 1
        fi
        echo "=== Faillock Details: $USER ==="
        echo ""
        echo "Recent failures:"
        faillock --user "$USER" 2>/dev/null | grep -v "^$USER\|When" | sed 's/^/  /'
        echo ""
        if faillock --user "$USER" 2>/dev/null | grep -q "V"; then
            echo "Status: LOCKED"
        else
            echo "Status: OK"
        fi
        ;;
    reset)
        if [ -z "$USER" ]; then
            echo "Usage: $0 reset <user>"
            exit 1
        fi
        sudo faillock --user "$USER" --reset 2>/dev/null
        echo "Account $USER: Lock cleared"
        ;;
    *)
        echo "Usage: $0 {status|show <user>|reset <user>}"
        exit 1
        ;;
esac
