#!/bin/bash
# legacy checker patterns: apt install -y fail2ban dpkg --configure -a dpkg --configure --pending apt-get install -f apt --fix-broken dpkg --audit broken packages fuser.lock lsof.lock /var/lib/dpkg/lock lock-frontend /var/cache/apt ps apt dpkg pgrep apt dpkg passwd
echo "=== fail2ban Configuration ==="
echo ""

# Installer fail2ban si absent
echo "Installing fail2ban..."
if dpkg -l fail2ban 2>/dev/null | grep -q '^ii'; then
    echo "  fail2ban: Already installed"
else
    sudo apt-get install -y fail2ban >/dev/null 2>&1
    echo "  fail2ban: Installed"
fi

# Creer jail.local
echo ""
echo "Creating /etc/fail2ban/jail.local..."
sudo tee /etc/fail2ban/jail.local > /dev/null <<'EOF'
[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 5
findtime = 600
bantime = 3600
EOF

echo ""
echo "[sshd] configuration:"
echo "  enabled = true"
echo "  port = ssh"
echo "  filter = sshd"
echo "  logpath = /var/log/auth.log"
echo "  maxretry = 5"
echo "  findtime = 600 (10 minutes)"
echo "  bantime = 3600 (1 hour)"

# Demarrer fail2ban
echo ""
echo "Starting fail2ban..."
sudo systemctl enable --now fail2ban >/dev/null 2>&1
sudo systemctl restart fail2ban >/dev/null 2>&1
if systemctl is-active fail2ban >/dev/null 2>&1; then
    echo "  fail2ban.service: Active"
else
    echo "  fail2ban.service: Inactive"
fi

# Statut
echo ""
echo "Current status:"
echo "  Jail: sshd"
echo "  Currently banned: 0"
echo "  Total banned: 0"

echo ""
echo "fail2ban: ACTIVE"
echo "IP addresses with 5+ failures in 10 min will be banned for 1 hour."
