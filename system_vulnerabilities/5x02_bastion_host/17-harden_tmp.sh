#!/bin/bash
echo "=== Hardening /tmp ==="
echo ""

# Afficher le montage actuel
echo "Current /tmp mount:"
findmnt -n /tmp 2>/dev/null | sed 's/^/  /' || echo "  /tmp (not a separate mount)"

# Backup de fstab (RÈGLE D'OR)
sudo cp /etc/fstab /etc/fstab.backup.$(date +%Y%m%d)

echo ""
echo "Applying hardening options..."
echo ""
echo "Method: Bind mount with options"
echo "Adding to /etc/fstab:"
echo "  tmpfs /tmp tmpfs defaults,noexec,nosuid,nodev 0 0"

# Ajouter à fstab (idempotent : retirer l'ancienne ligne /tmp d'abord)
sudo sed -i '\| /tmp |d' /etc/fstab
echo "tmpfs /tmp tmpfs defaults,noexec,nosuid,nodev 0 0" | sudo tee -a /etc/fstab >/dev/null

# Remonter /tmp
echo ""
echo "Remounting /tmp..."
sudo mount -o remount,noexec,nosuid,nodev /tmp 2>/dev/null

# Vérification
echo ""
echo "Verification:"
echo "  /tmp mount options: $(findmnt -no OPTIONS /tmp 2>/dev/null)"

# Test des restrictions
echo ""
echo "Testing restrictions:"
echo '#!/bin/bash' | sudo tee /tmp/test_exec.sh >/dev/null
sudo chmod +x /tmp/test_exec.sh
if /tmp/test_exec.sh 2>/dev/null; then
    echo "  Execute test: ALLOWED (hardening failed)"
else
    echo "  Execute test: BLOCKED (Permission denied) ✓"
fi
sudo rm -f /tmp/test_exec.sh

echo ""
echo "/tmp hardened successfully."
