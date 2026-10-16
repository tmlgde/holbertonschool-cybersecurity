#!/bin/bash
echo "=== Notification Configuration ==="
echo ""

CONFIG="/etc/apt/apt.conf.d/50unattended-upgrades"

# Backup
if [ -f "$CONFIG" ]; then
    sudo cp "$CONFIG" "${CONFIG}.backup.$(date +%Y%m%d)"
fi

# Idempotence : supprimer d'anciennes directives Mail/Syslog
sudo sed -i '/Unattended-Upgrade::Mail/d; /Unattended-Upgrade::Syslog/d' "$CONFIG" 2>/dev/null

# Ajouter les directives de notification et logging
sudo tee -a "$CONFIG" > /dev/null <<'EOF'
Unattended-Upgrade::Mail "root";
Unattended-Upgrade::MailOnlyOnError "false";
Unattended-Upgrade::MailReport "on-change";
Unattended-Upgrade::SyslogEnable "true";
Unattended-Upgrade::SyslogFacility "daemon";
EOF

echo "Email settings:"
echo '  Mail::OnlyOnError: "false"'
echo '  Mail::Report: "on-change"'
echo "  Recipient: root (local delivery)"
echo ""
echo "Logging settings:"
echo '  Syslog::Enable: "true"'
echo '  Syslog::Facility: "daemon"'
echo ""
echo "Log locations:"
echo "  /var/log/unattended-upgrades/unattended-upgrades.log"
echo "  /var/log/unattended-upgrades/unattended-upgrades-dpkg.log"
echo ""
echo "Notification system configured."
echo "All update activity will be logged and reported."
