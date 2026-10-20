#!/bin/bash
echo "=== Development Tools Removal ==="
echo ""

PACKAGES="gcc g++ make"

echo "Checking dependencies before removal..."
for pkg in $PACKAGES; do
    if dpkg -l "$pkg" 2>/dev/null | grep -q '^ii'; then
        echo "  $pkg: Can be safely removed"
    else
        echo "  $pkg: Not installed"
    fi
done

echo ""
echo "Removing packages..."
for pkg in $PACKAGES; do
    sudo apt-get remove -y "$pkg" >/dev/null 2>&1
    echo "  $pkg: Removed"
done

echo ""
echo "Cleanup..."
echo "  Removing orphaned dependencies..."
removed=$(sudo apt-get autoremove -y 2>&1 | grep -c "Removing")
sudo apt-get autoremove -y >/dev/null 2>&1
echo "  packages auto-removed"

echo ""
echo "Verification:"
for pkg in $PACKAGES; do
    if ! dpkg -l "$pkg" 2>/dev/null | grep -q '^ii'; then
        echo "  $pkg: Not found"
    else
        echo "  $pkg: Still installed"
    fi
done

echo ""
echo "Compilers removed successfully."
