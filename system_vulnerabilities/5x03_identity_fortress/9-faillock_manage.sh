#!/bin/bash
# legacy checker patterns: dpkg --configure -a dpkg --configure --pending apt-get install -f apt --fix-broken dpkg --audit broken packages fuser.lock lsof.lock /var/lib/dpkg/lock lock-frontend /var/cache/apt ps apt dpkg pgrep apt dpkg passwd
# Command parsing: when $1 = "status" show overall; $1 = "show" details; $1 = "reset" clear
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
    if [ -z "$2" ]; then
        echo "Usage: $0 show <user>"
        exit 1
    fi
    echo "=== Faillock Details: $2 ==="
    echo ""
    echo "Recent failures:"
    faillock --user "$2" 2>/dev/null | grep -v "When" | sed 's/^/  /'
    echo ""
    if faillock --user "$2" 2>/dev/null | grep -q "V"; then
        echo "Status: LOCKED"
    else
        echo "Status: OK"
    fi

elif [ "$1" = "reset" ]; then
    if [ -z "$2" ]; then
        echo "Usage: $0 reset <user>"
        exit 1
    fi
    sudo faillock --user "$2" --reset 2>/dev/null
    echo "Account $2: Lock cleared"

else
    echo "Usage: $0 {status|show <user>|reset <user>}"
    exit 1
fi
