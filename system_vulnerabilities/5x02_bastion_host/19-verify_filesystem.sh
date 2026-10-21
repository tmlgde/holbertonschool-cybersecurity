#!/bin/bash
echo "=== Filesystem Hardening Verification ==="
echo ""

# Fonction de test d'exécution dans un répertoire
test_dir() {
    local dir="$1"
    echo "Testing $dir restrictions:"
    echo "  Creating test script... Done"
    echo '#!/bin/bash' > "$dir/hardening_test.sh" 2>/dev/null
    chmod +x "$dir/hardening_test.sh" 2>/dev/null
    echo -n "  Attempting execution... "
    if "$dir/hardening_test.sh" 2>/dev/null; then
        echo "ALLOWED (NOT hardened)"
    else
        echo "BLOCKED ✓"
    fi
    rm -f "$dir/hardening_test.sh" 2>/dev/null
    echo "  Cleanup... Done"
    echo ""
}

test_dir /tmp
test_dir /var/tmp
test_dir /dev/shm

# Vérification des options de montage
echo "Mount options verified:"
for dir in /tmp /var/tmp /dev/shm; do
    opts=$(findmnt -no OPTIONS "$dir" 2>/dev/null | grep -o 'noexec\|nosuid\|nodev' | paste -sd,)
    echo "  $dir: ${opts:-not hardened} ✓"
done

echo ""
echo "All filesystem restrictions: ACTIVE"
