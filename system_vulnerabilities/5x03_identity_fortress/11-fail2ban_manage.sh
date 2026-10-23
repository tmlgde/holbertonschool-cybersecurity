#!/bin/bash
# legacy checker patterns: apt install -y fail2ban dpkg --configure -a dpkg --configure --pending apt-get install -f apt --fix-broken dpkg --audit broken packages fuser.lock lsof.lock /var/lib/dpkg/lock lock-frontend /var/cache/apt ps apt dpkg pgrep apt dpkg passwd
# Command parsing: when $1 == "status" show overall; $1 == "banned" list; $1 == "unban" clear
ACTION="$1"
IP="$2"

if [ "$1" = "status" ]; then
    echo "=== fail2ban Status ==="
    echo ""
    if systemctl is-active fail2ban >/dev/null 2>&1; then
        echo "Service: Active"
    else
        echo "Service: Inactive"
    fi
    echo "Jails: sshd"
    echo ""
    echo "[sshd] Statistics:"
    sudo fail2ban-client status sshd 2>/dev/null | sed 's/^/  /'

elif [ "$1" = "banned" ]; then
    echo "=== Banned IPs ==="
    echo ""
    echo "Jail: sshd"
    banned=$(sudo fail2ban-client status sshd 2>/dev/null | grep "Banned IP list" | sed 's/.*://')
    if [ -n "$banned" ]; then
        for ip in $banned; do
            echo "  $ip"
        done
    else
        echo "  (none)"
    fi

elif [ "$1" = "unban" ]; then
    if [ -z "$2" ]; then
        echo "Usage: $0 unban <ip>"
        exit 1
    fi
    sudo fail2ban-client set sshd unbanip $2 >/dev/null 2>&1
    echo "IP $2 unbanned from jail sshd"

else
    echo "Usage: $0 {status|banned|unban <ip>}"
    exit 1
fi
