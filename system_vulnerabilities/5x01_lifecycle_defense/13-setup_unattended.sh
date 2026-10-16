#!/bin/bash
echo "=== Unattended-Upgrades Setup ==="
echo ""

CONFIG="/etc/apt/apt.conf.d/20auto-upgrades"

# Backup si le fichier existe déjà (règle d'or)
if [ -f "$CONFIG" ]; then
    sudo cp "$CONFIG" "${CONFIG}.backup.$(date +%Y%m%d)"
fi

# Écrire la configuration
echo "Configuring $CONFIG..."
sudo tee "$CONFIG" > /dev/null <<'EOF'
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
EOF

# Afficher le contenu écrit
echo '  APT::Periodic::Update-Package-Lists "1";'
echo '  APT::Periodic::Unattended-Upgrade "1";'
echo '  APT::Periodic::Download-Upgradeable-Packages "1";'
echo '  APT::Periodic::AutocleanInterval "7";'

# Activer les timers systemd
echo ""
echo "Enabling systemd timers..."
sudo systemctl enable apt-daily.timer >/dev/null 2>&1
echo "  apt-daily.timer: Enabled"
sudo systemctl enable apt-daily-upgrade.timer >/dev/null 2>&1
echo "  apt-daily-upgrade.timer: Enabled"

# Vérification
echo ""
echo "Verification:"
if systemctl is-enabled apt-daily-upgrade.timer >/dev/null 2>&1; then
    echo "  Unattended-upgrades: ACTIVE"
else
    echo "  Unattended-upgrades: INACTIVE"
fi

next=$(systemctl list-timers apt-daily-upgrade.timer --no-legend 2>/dev/null | awk '{print $1, $2, $3}')
echo "  Next scheduled run: ${next:-Scheduled}"

echo ""
echo "Basic setup complete."
