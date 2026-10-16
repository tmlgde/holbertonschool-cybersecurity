#!/bin/bash
echo "=== Package Repair ==="
echo ""
echo "Configuring interrupted packages..."
sudo dpkg --configure -a
echo ""
echo "Fixing broken dependencies..."
sudo apt-get install -f -y
echo ""
echo "Verification:"
echo "  Half-configured packages: $(dpkg -l | grep -c '^iF')"
# Les dépendances cassées : apt-get check les détecte
broken=$(sudo apt-get check 2>&1 | grep -c "broken")
echo "  Broken dependencies: $broken"
echo ""
if [ "$(dpkg -l | grep -c '^iF')" -eq 0 ]; then
    echo "Package database: CONSISTENT"
else
    echo "Package database: INCONSISTENT"
fi
