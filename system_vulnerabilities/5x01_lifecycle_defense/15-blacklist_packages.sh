#!/bin/bash
echo "=== Package Blacklist Configuration ==="
echo ""

CONFIG="/etc/apt/apt.conf.d/50unattended-upgrades"

# Backup si le fichier existe
if [ -f "$CONFIG" ]; then
    sudo cp "$CONFIG" "${CONFIG}.backup.$(date +%Y%m%d)"
fi

echo "Adding to Unattended-Upgrade::Package-Blacklist:"
echo '  + "apache2"'
echo '  + "apache2-bin"'
echo '  + "mysql-server"'
echo '  + "mysql-server-*"'
echo '  + "nginx"'
echo '  + "docker-ce"'

# Supprimer un ancien bloc Package-Blacklist pour éviter les doublons (idempotence)
sudo sed -i '/Unattended-Upgrade::Package-Blacklist {/,/};/d' "$CONFIG" 2>/dev/null

# Ajouter le bloc blacklist à la fin du fichier
sudo tee -a "$CONFIG" > /dev/null <<'EOF'
Unattended-Upgrade::Package-Blacklist {
    "apache2";
    "apache2-bin";
    "mysql-server";
    "mysql-server-*";
    "nginx";
    "docker-ce";
};
EOF

echo ""
echo "Blacklist written to $CONFIG"
echo ""
echo "These packages will NOT be automatically upgraded."
echo "Manual review required for security updates."
