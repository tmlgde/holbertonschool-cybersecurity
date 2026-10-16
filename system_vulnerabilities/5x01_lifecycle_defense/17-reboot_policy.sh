#!/bin/bash
echo "=== Automatic Reboot Policy ==="
echo ""

CONFIG="/etc/apt/apt.conf.d/50unattended-upgrades"

# Backup
if [ -f "$CONFIG" ]; then
    sudo cp "$CONFIG" "${CONFIG}.backup.$(date +%Y%m%d)"
fi

echo "Configuring $CONFIG..."
echo ""

# Idempotence : supprimer d'anciennes directives de reboot si présentes
sudo sed -i '/Unattended-Upgrade::Automatic-Reboot/d' "$CONFIG" 2>/dev/null

# Ajouter les directives de reboot à la fin
sudo tee -a "$CONFIG" > /dev/null <<'EOF'
Unattended-Upgrade::Automatic-Reboot "true";
Unattended-Upgrade::Automatic-Reboot-Time "04:00";
Unattended-Upgrade::Automatic-Reboot-WithUsers "false";
EOF

echo "Reboot settings:"
echo '  Automatic-Reboot: "true"'
echo '  Automatic-Reboot-Time: "04:00"'
echo '  Automatic-Reboot-WithUsers: "false"'
echo ""
echo "Additional safeguards:"
echo "  Reboot only when required (kernel/libc updates)"
echo "  Skip reboot if users are logged in"
echo ""
echo "Reboot policy configured."
echo "System will auto-reboot at 04:00 when required."
