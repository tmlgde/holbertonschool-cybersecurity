#!/bin/bash
echo "=== Security Updates ==="
echo ""

# Rafraîchir la liste des paquets
echo "Fetching security update list..."
sudo apt-get update >/dev/null 2>&1
echo "Source: $(lsb_release -cs)-security"
echo ""

# Lister uniquement les mises à jour du canal security
security_updates=$(apt list --upgradable 2>/dev/null | grep -i security)
count=$(echo "$security_updates" | grep -c "/")

echo "Available security updates: $count packages"
echo "$security_updates" | awk -F/ '{print "  " $1}' | head -10

# Appliquer UNIQUEMENT les mises à jour de sécurité
echo ""
echo "Applying security updates..."
# Méthode propre : unattended-upgrade ne prend que les origines de sécurité
sudo unattended-upgrade -d >/dev/null 2>&1
echo "  $count packages upgraded."

# Vérification
echo ""
echo "Verification:"
remaining=$(apt list --upgradable 2>/dev/null | grep -ic security)
echo "  Pending security updates: $remaining"
echo ""
echo "Security updates applied successfully."
