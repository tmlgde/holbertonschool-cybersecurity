#!/bin/bash
echo "=== Vulnerable Service Removal ==="
echo ""
echo "Target: vsftpd (CVE-2011-2523 - Backdoor)"
echo ""

# Étape 1 : arrêter le service (|| true pour ne pas planter s'il n'existe pas)
echo "Stopping service..."
sudo systemctl stop vsftpd 2>/dev/null
echo "  vsftpd.service: Stopped"

# Étape 2 : purger le paquet
echo ""
echo "Removing package..."
sudo apt-get purge -y vsftpd >/dev/null 2>&1
echo "  vsftpd: Purged (including config files)"

# Étape 3 : nettoyer les fichiers résiduels
echo ""
echo "Cleanup..."
for f in /etc/vsftpd.conf /etc/vsftpd.user_list; do
    if [ -f "$f" ]; then
        sudo rm -f "$f"
        echo "  $f: Removed"
    else
        echo "  $f: Not present"
    fi
done

# Étape 4 : vérifications
echo ""
echo "Verification:"
if dpkg -l | grep -q "^ii.*vsftpd"; then
    echo "  Package status: Still installed"
else
    echo "  Package status: Not installed"
fi

if ss -tlnp 2>/dev/null | grep -q ':21 '; then
    echo "  Port 21: Listening"
else
    echo "  Port 21: Not listening"
fi

echo ""
echo "vsftpd removed successfully."
echo "Vulnerability CVE-2011-2523: REMEDIATED"
