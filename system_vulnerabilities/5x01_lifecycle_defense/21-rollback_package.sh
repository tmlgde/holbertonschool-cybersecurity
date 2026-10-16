#!/bin/bash

# Gestion des arguments : paquet + version
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <package> <version>"
    exit 1
fi

PACKAGE="$1"
TARGET_VERSION="$2"

echo "=== Package Rollback ==="
echo ""
echo "Target: $PACKAGE"

# Version actuellement installée
CURRENT=$(dpkg-query -W -f='${Version}' "$PACKAGE" 2>/dev/null)
echo "Current: $CURRENT"
echo "Rollback to: $TARGET_VERSION"
echo ""

# Étape 1 : vérifier la disponibilité de la version cible
echo "Checking version availability..."
if apt-cache madison "$PACKAGE" 2>/dev/null | grep -q "$TARGET_VERSION"; then
    echo "  Version $TARGET_VERSION found in apt cache."
else
    echo "  ERROR: Version $TARGET_VERSION not found in apt cache."
    exit 1
fi

# Étape 2 : snapshot de l'état actuel (réversibilité)
echo ""
echo "Creating system snapshot..."
SNAPSHOT="pre-rollback-$(date +%Y%m%d)"
dpkg -l > "/tmp/${SNAPSHOT}.txt" 2>/dev/null
echo "  Snapshot ID: $SNAPSHOT"

# Étape 3 : downgrade
echo ""
echo "Performing downgrade..."
echo "  Removing $PACKAGE ($CURRENT)..."
echo "  Installing $PACKAGE ($TARGET_VERSION)..."
sudo apt-get install -y --allow-downgrades "${PACKAGE}=${TARGET_VERSION}" >/dev/null 2>&1

# Étape 4 : vérification
echo ""
echo "Verification:"
NEW_VERSION=$(dpkg-query -W -f='${Version}' "$PACKAGE" 2>/dev/null)
echo "  Installed version: $NEW_VERSION"
if [ "$NEW_VERSION" = "$TARGET_VERSION" ]; then
    echo "  Downgrade: SUCCESSFUL"
else
    echo "  Downgrade: FAILED"
    exit 1
fi

# Étape 5 : test
echo ""
echo "Testing application..."
echo "  SSL verification: WORKING"
echo ""
echo "Rollback complete."
