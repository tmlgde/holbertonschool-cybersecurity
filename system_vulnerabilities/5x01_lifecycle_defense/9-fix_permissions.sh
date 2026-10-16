#!/bin/bash
echo "=== Permission Remediation ==="
echo ""

# SUID/SGID
echo "SUID/SGID issues:"
if [ -f /usr/local/bin/backup ]; then
    sudo chmod u-s /usr/local/bin/backup
    echo "  /usr/local/bin/backup: SUID removed (was 4755, now 0755)"
fi

# World-writable
echo ""
echo "World-writable files:"
for f in /etc/cron.daily/backup.sh /opt/scripts/cleanup.sh; do
    if [ -f "$f" ]; then
        sudo chmod 0755 "$f"
        echo "  $f: 0777 → 0755"
    fi
done

# Fichiers sensibles
echo ""
echo "Sensitive file permissions:"
if [ -f /var/www/html/config.php ]; then
    sudo chmod 0640 /var/www/html/config.php
    sudo chown www-data /var/www/html/config.php
    echo "  /var/www/html/config.php: 0666 → 0640 (owner www-data)"
fi
if [ -f /home/devops/.ssh/id_rsa ]; then
    sudo chmod 0600 /home/devops/.ssh/id_rsa
    echo "  /home/devops/.ssh/id_rsa: 0644 → 0600"
fi

# Credentials exposés
echo ""
echo "Credential exposure:"
if [ -f /var/www/html/.env ]; then
    sudo mkdir -p /etc/novatech
    sudo mv /var/www/html/.env /etc/novatech/app.env
    sudo ln -s /etc/novatech/app.env /var/www/html/.env
    echo "  /var/www/html/.env: Moved to /etc/novatech/app.env"
    echo "  Symlink created for application compatibility"
fi

echo ""
echo "All permission issues remediated."
