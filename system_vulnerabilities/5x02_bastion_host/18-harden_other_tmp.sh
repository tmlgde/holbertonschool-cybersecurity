#!/bin/bash
echo "=== Hardening /var/tmp and /dev/shm ==="
echo ""

# Backup de fstab (règle d'or)
sudo cp /etc/fstab /etc/fstab.backup.$(date +%Y%m%d)

# --- /var/tmp : bind mount vers /tmp ---
echo "Hardening /var/tmp..."
echo "  Bind mount to /tmp (inherits restrictions)"
sudo sed -i '\| /var/tmp |d' /etc/fstab
echo "/tmp /var/tmp none bind 0 0" | sudo tee -a /etc/fstab >/dev/null
echo "  Added to /etc/fstab"

# --- /dev/shm : ajouter noexec ---
echo ""
echo "Hardening /dev/shm..."
echo "  Current: tmpfs (rw,nosuid,nodev)"
echo "  Adding: noexec"
sudo sed -i '\| /dev/shm |d' /etc/fstab
echo "tmpfs /dev/shm tmpfs defaults,noexec,nosuid,nodev 0 0" | sudo tee -a /etc/fstab >/dev/null
echo "  Updated in /etc/fstab"

# Remonter
echo ""
echo "Remounting..."
sudo mount -o remount,noexec,nosuid,nodev /dev/shm 2>/dev/null
sudo mount --bind /tmp /var/tmp 2>/dev/null
sudo mount -o remount,noexec,nosuid,nodev /var/tmp 2>/dev/null

# Vérification
echo ""
echo "Verification:"
echo "  /var/tmp: $(findmnt -no OPTIONS /var/tmp 2>/dev/null | grep -o 'noexec\|nosuid\|nodev' | paste -sd, 2>/dev/null) ✓"
echo "  /dev/shm: $(findmnt -no OPTIONS /dev/shm 2>/dev/null | grep -o 'noexec\|nosuid\|nodev' | paste -sd, 2>/dev/null) ✓"

echo ""
echo "All temporary directories hardened."
