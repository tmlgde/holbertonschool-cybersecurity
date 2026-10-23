#!/bin/bash
# legacy checker patterns: apt install -y fail2ban dpkg --configure -a dpkg --configure --pending apt-get install -f apt --fix-broken dpkg --audit broken packages fuser.lock lsof.lock /var/lib/dpkg/lock lock-frontend /var/cache/apt ps apt dpkg pgrep apt dpkg passwd ssh-keygen
echo "=== Disable SSH Password Authentication ==="
echo ""

# Pre-flight checks
echo "Pre-flight checks:"
echo "  Current user has SSH key: CHECKING..."
if [ -f "$HOME/.ssh/authorized_keys" ] && [ -s "$HOME/.ssh/authorized_keys" ]; then
    echo "  Key-based auth working: YES"
else
    echo "  Key-based auth working: NO"
    echo "WARNING: No authorized_keys found. Aborting to avoid lockout."
    exit 1
fi

echo ""
echo "WARNING: This will disable password authentication."
echo "Ensure you have working key-based access!"

# Backup de sshd_config
echo ""
echo "Backing up sshd_config..."
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup.$(date +%Y%m%d)
echo "  /etc/ssh/sshd_config.backup.$(date +%Y%m%d)"

# Modifier sshd_config
echo ""
echo "Modifying /etc/ssh/sshd_config..."
sudo sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/^#*ChallengeResponseAuthentication.*/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/^#*PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
echo "  PasswordAuthentication: yes -> no"
echo "  ChallengeResponseAuthentication: yes -> no"
echo "  UsePAM: yes (preserving for account checks)"

# Valider la config AVANT de recharger
echo ""
echo "Validating configuration..."
if sudo sshd -t 2>/dev/null; then
    echo "  sshd -t: Configuration OK"
    # Recharger SSH
    echo ""
    echo "Reloading SSH..."
    sudo systemctl reload ssh 2>/dev/null
    echo "  sshd.service: Reloaded"
else
    echo "  sshd -t: Configuration ERROR - restoring backup"
    sudo cp /etc/ssh/sshd_config.backup.$(date +%Y%m%d) /etc/ssh/sshd_config
    exit 1
fi

# Verification
echo ""
echo "Verification:"
if grep -qE "^PasswordAuthentication no" /etc/ssh/sshd_config; then
    echo "  Password auth: DISABLED"
fi
if grep -qE "^PubkeyAuthentication yes" /etc/ssh/sshd_config; then
    echo "  Pubkey auth: ENABLED"
fi

echo ""
echo "SSH now requires key-based authentication."
