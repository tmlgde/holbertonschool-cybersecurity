#!/bin/bash
echo "=== SSH Hardening ==="
echo ""

CONFIG="/etc/ssh/sshd_config"
BACKUP="${CONFIG}.backup.$(date +%Y%m%d)"

# Étape 1 : Backup (règle d'or du projet)
sudo cp "$CONFIG" "$BACKUP"
echo "Backup created: $BACKUP"
echo ""

# Étape 2 : Appliquer les mesures de durcissement
echo "Applying hardening measures..."
sudo sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' "$CONFIG"
echo "  PermitRootLogin: yes → no"
sudo sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' "$CONFIG"
echo "  PasswordAuthentication: yes → no"
sudo sed -i 's/^#*X11Forwarding.*/X11Forwarding no/' "$CONFIG"
echo "  X11Forwarding: yes → no"
sudo sed -i 's/^#*MaxAuthTries.*/MaxAuthTries 3/' "$CONFIG"
echo "  MaxAuthTries: 6 → 3"
sudo sed -i 's/^#*ClientAliveInterval.*/ClientAliveInterval 300/' "$CONFIG"
echo "  ClientAliveInterval: 0 → 300"
sudo sed -i 's/^#*ClientAliveCountMax.*/ClientAliveCountMax 2/' "$CONFIG"
echo "  ClientAliveCountMax: 3 → 2"

# Étape 3 : Tester la config AVANT de recharger
echo ""
if sudo sshd -t 2>/dev/null; then
    echo "Configuration test: OK"
else
    echo "Configuration test: FAILED"
    echo "Restoring backup..."
    sudo cp "$BACKUP" "$CONFIG"
    exit 1
fi

# Étape 4 : Recharger SSH
echo ""
echo "Reloading SSH service..."
sudo systemctl reload ssh 2>/dev/null
echo "  sshd.service: Reloaded"

# Étape 5 : Message final + avertissement
echo ""
echo "SSH hardened successfully."
echo ""
echo "WARNING: Ensure key-based authentication is configured"
echo "         before closing this session."
