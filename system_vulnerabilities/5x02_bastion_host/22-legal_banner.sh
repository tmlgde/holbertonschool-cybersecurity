#!/bin/bash
echo "=== Legal Banner Configuration ==="
echo ""
echo "Creating banner in /etc/issue.net..."

# Backup de sshd_config (règle d'or)
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup.$(date +%Y%m%d)

# Créer la bannière
sudo tee /etc/issue.net > /dev/null <<'EOF'
=====================================
AUTHORIZED ACCESS ONLY

This system is the property of NovaTech Solutions.
Unauthorized access is prohibited and will be prosecuted.
All activities are monitored and logged.
=====================================
EOF

echo ""
echo "Banner content:"
cat /etc/issue.net | sed 's/^/  /'

# Configurer SSH pour afficher la bannière
echo ""
echo "Configuring SSH to display banner..."
sudo sed -i 's|^#*Banner.*|Banner /etc/issue.net|' /etc/ssh/sshd_config
# Si la directive Banner n'existe pas du tout, l'ajouter
if ! grep -q "^Banner /etc/issue.net" /etc/ssh/sshd_config; then
    echo "Banner /etc/issue.net" | sudo tee -a /etc/ssh/sshd_config >/dev/null
fi
echo "  Banner /etc/issue.net: Enabled"

# Recharger SSH (après test)
echo ""
echo "Reloading SSH..."
if sudo sshd -t 2>/dev/null; then
    sudo systemctl reload ssh 2>/dev/null
fi

# Vérification
echo ""
echo "Verification:"
if [ -f /etc/issue.net ]; then
    echo "  /etc/issue.net: EXISTS ✓"
else
    echo "  /etc/issue.net: MISSING ✗"
fi
if grep -q "^Banner /etc/issue.net" /etc/ssh/sshd_config; then
    echo "  SSH Banner config: ENABLED ✓"
else
    echo "  SSH Banner config: NOT SET ✗"
fi

echo ""
echo "Legal banner configured."
