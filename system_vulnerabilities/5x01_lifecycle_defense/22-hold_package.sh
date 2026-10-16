#!/bin/bash

# Gestion des arguments : paquet + raison
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <package> <reason>"
    exit 1
fi

PACKAGE="$1"
REASON="$2"

echo "=== Package Hold ==="
echo ""
echo "Package: $PACKAGE"

# Version actuelle
CURRENT=$(dpkg-query -W -f='${Version}' "$PACKAGE" 2>/dev/null)
echo "Current version: $CURRENT"
echo ""

# Étape 1 : poser le hold
echo "Placing hold..."
sudo apt-mark hold "$PACKAGE" >/dev/null 2>&1
echo "  apt-mark hold $PACKAGE: Done"

# Étape 2 : logger la raison (traçabilité)
echo ""
echo "Logging hold reason..."
LOG="/var/log/package_holds.log"
echo "$(date '+%Y-%m-%d %H:%M:%S') | $PACKAGE | $CURRENT | $REASON" | sudo tee -a "$LOG" >/dev/null
echo "  $LOG updated"

# Étape 3 : vérifier le hold
echo ""
echo "Hold verification:"
if apt-mark showhold 2>/dev/null | grep -q "^${PACKAGE}$"; then
    echo "  $PACKAGE set on hold."
else
    echo "  ERROR: Hold not applied."
    exit 1
fi

# Étape 4 : avertissement sur le risque
echo ""
echo "WARNING: This package will NOT receive automatic updates."
echo "         Including security updates."
echo "         Review required within 30 days."
echo ""
echo "Hold applied successfully."
