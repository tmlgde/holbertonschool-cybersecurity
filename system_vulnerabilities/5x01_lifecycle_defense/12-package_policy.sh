#!/bin/bash

# Gestion d'erreur : vérifier qu'un argument est fourni
if [ -z "$1" ]; then
    echo "Usage: $0 <package>"
    exit 1
fi

PACKAGE="$1"
echo "=== Package Policy Analysis ==="
echo ""
echo "Package: $PACKAGE"
POLICY=$(LC_ALL=C apt-cache policy "$PACKAGE")

installed=$(echo "$POLICY" | grep "Installed:" | awk '{print $2}')
candidate=$(echo "$POLICY" | grep "Candidate:" | awk '{print $2}')

echo "Installed: $installed"
echo "Candidate: $candidate"
echo ""
echo "Available versions:"
echo "$POLICY" | awk '/^ +[0-9]+\.[0-9]/ {print "  " $1 "  (priority " $2 ")"}'
echo ""
echo "Analysis:"
if [ "$installed" != "$candidate" ]; then
    echo "  Update available: YES"
    echo "  Recommendation: Update to $candidate"
else
    echo "  Update available: NO"
    echo "  Recommendation: Package is up to date"
fi
