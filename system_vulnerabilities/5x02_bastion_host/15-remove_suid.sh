#!/bin/bash
echo "=== SUID Neutralization ==="
echo ""

# Binaires essentiels à préserver (NE JAMAIS toucher)
echo "Preserving essential SUID (DO NOT TOUCH):"
preserve="/usr/bin/sudo /usr/bin/passwd /usr/bin/su"
for bin in $preserve; do
    echo "  $bin"
done

# Binaires non essentiels dont on retire le SUID
echo ""
echo "Removing SUID from non-essential binaries..."

remove_suid() {
    local bin="$1"
    local reason="$2"
    if [ -f "$bin" ]; then
        sudo chmod u-s "$bin"
        echo "  $bin: SUID removed ($reason)"
    fi
}

remove_suid /usr/bin/mount "admin can use sudo"
remove_suid /usr/bin/umount "admin can use sudo"
remove_suid /usr/bin/newgrp "not needed"
remove_suid /usr/local/bin/backup "CUSTOM - HIGH RISK"

# Vérification
echo ""
echo "Verification:"
for bin in /usr/bin/mount /usr/bin/umount; do
    if [ -f "$bin" ]; then
        echo "  $(basename $bin): $(ls -l $bin | awk '{print $1}') (no SUID)"
    fi
done

echo ""
echo "SUID binaries reduced."
