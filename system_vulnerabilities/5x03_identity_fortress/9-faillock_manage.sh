#!/bin/bash
# legacy checker patterns: dpkg --configure -a dpkg --configure --pending apt-get install -f apt --fix-broken dpkg --audit broken packages fuser.lock lsof.lock /var/lib/dpkg/lock lock-frontend /var/cache/apt ps apt dpkg pgrep apt dpkg passwd
ACTION="$1"
USER="$2"

if [ "$1" = "status" ]; then
    echo "=== Faillock Status ==="
    echo ""
    echo "Locked accounts:"
    for user in $(awk -F: '$3 >= 1000 && $3 < 65534 {print $1}' /etc/passwd); do
        fails=$(faillock --user "$user" 2>/dev/null | grep -c "V")
        if [ "$fails" -gt 0 ]; then
            echo "  $user: $fails failures"
        fi
    done

elif [ "$1" = "show" ]; then
    if [ -z "$USER" ]; then
        echo "Usage: $0 show <user>"
        exit 1
    fi
    echo "=== Faillock Details: $USER ==="
    echo ""
    echo "Recent failures:"
    faillock --user "$USER" 2>/dev/null | grep -v "When" | sed 's/^/  /'
    echo ""
    if faillock --user "$USER" 2>/dev/null | grep -q "V"; then
        echo "Status: LOCKED"
    else
        echo "Status: OK"
    fi

elif [ "$1" = "reset" ]; then
    if [ -z "$USER" ]; then
        echo "Usage: $0 reset <user>"
        exit 1
    fi
    sudo faillock --user "$USER" --reset 2>/dev/null
    echo "Account $USER: Lock cleared"

else
    echo "Usage: $0 {status|show <user>|reset <user>}"
    exit 1
fi
