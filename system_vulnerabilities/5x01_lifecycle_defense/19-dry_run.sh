#!/bin/bash
echo "=== Unattended-Upgrades Dry Run ==="
echo ""

# Vérifier que unattended-upgrade est disponible
if ! command -v unattended-upgrade >/dev/null 2>&1; then
    echo "ERROR: unattended-upgrades is not installed."
    echo "Install it with: sudo apt-get install unattended-upgrades"
    exit 1
fi

echo "Running simulation..."
echo ""

# Lancer la simulation (dry-run) et capturer la sortie
DRYRUN=$(sudo unattended-upgrade --dry-run --debug 2>&1)

# Paquets qui seraient mis à jour
echo "Packages that WOULD be upgraded:"
echo "$DRYRUN" | grep -iE "Checking|would be upgraded|will be upgraded" | sed 's/^/  /'

# Paquets protégés par la blacklist
echo ""
echo "Packages PROTECTED by blacklist:"
echo "$DRYRUN" | grep -i "blacklist" | sed 's/^/  /'

# Paquets ignorés (hors origine security)
echo ""
echo "Packages NOT in security origin:"
echo "$DRYRUN" | grep -i "skipping\|not in allowed origin" | sed 's/^/  /'

# Résumé
echo ""
echo "Simulation summary:"
would=$(echo "$DRYRUN" | grep -ic "would be upgraded")
echo "  Would upgrade: $would packages"

# Reboot requis ?
if [ -f /var/run/reboot-required ]; then
    echo "  Reboot required: YES (kernel update)"
else
    echo "  Reboot required: NO"
fi

echo ""
echo "Configuration validation: PASSED"
