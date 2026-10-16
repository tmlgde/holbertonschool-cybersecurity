#!/bin/bash
echo "=== Security-Only Configuration ==="
echo ""

CONFIG="/etc/apt/apt.conf.d/50unattended-upgrades"

# Backup si le fichier existe
if [ -f "$CONFIG" ]; then
    sudo cp "$CONFIG" "${CONFIG}.backup.$(date +%Y%m%d)"
fi

echo "Configuring $CONFIG..."
echo ""

# Écrire la configuration Allowed-Origins (security only)
sudo tee "$CONFIG" > /dev/null <<'EOF'
Unattended-Upgrade::Allowed-Origins {
    "${distro_id}:${distro_codename}-security";
    "${distro_id}ESMApps:${distro_codename}-apps-security";
    "${distro_id}ESM:${distro_codename}-infra-security";
//  "${distro_id}:${distro_codename}-updates";
//  "${distro_id}:${distro_codename}-backports";
};
EOF

# Afficher ce qui a été configuré
echo "Allowed-Origins:"
echo '  [ENABLED]  "${distro_id}:${distro_codename}-security"'
echo '  [ENABLED]  "${distro_id}ESMApps:${distro_codename}-apps-security"'
echo '  [ENABLED]  "${distro_id}ESM:${distro_codename}-infra-security"'
echo '  [DISABLED] "${distro_id}:${distro_codename}-updates"'
echo '  [DISABLED] "${distro_id}:${distro_codename}-backports"'

echo ""
echo "Security-only filter applied."
echo "Only security updates will be installed automatically."
