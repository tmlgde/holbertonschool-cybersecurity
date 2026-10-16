#!/bin/bash
echo "=== Configuration Backup ==="
echo ""

# Liste des fichiers/dossiers de config à sauvegarder
CONFIGS=(
    /etc/apt/apt.conf.d/20auto-upgrades
    /etc/apt/apt.conf.d/50unattended-upgrades
    /etc/apt/sources.list
    /etc/apt/sources.list.d
    /etc/systemd/system/apt-daily.timer.d
    /etc/systemd/system/apt-daily-upgrade.timer.d
    /var/log/package_holds.log
)

echo "Collecting configuration files..."
# Ne garder que ceux qui existent réellement
EXISTING=()
for item in "${CONFIGS[@]}"; do
    if [ -e "$item" ]; then
        echo "  $item"
        EXISTING+=("$item")
    fi
done

# Créer l'archive horodatée
echo ""
echo "Creating archive..."
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
ARCHIVE="/var/backups/patch-config-${TIMESTAMP}.tar.gz"
sudo tar -czf "$ARCHIVE" "${EXISTING[@]}" 2>/dev/null
echo "  $ARCHIVE"

# Contenu de l'archive
echo ""
echo "Archive contents:"
nbfiles=$(sudo tar -tzf "$ARCHIVE" 2>/dev/null | wc -l)
size=$(sudo du -h "$ARCHIVE" 2>/dev/null | awk '{print $1}')
echo "  $nbfiles files, $size total"

# Empreinte SHA256
echo ""
sha=$(sudo sha256sum "$ARCHIVE" 2>/dev/null | awk '{print $1}')
echo "SHA256: $sha"

echo ""
echo "Backup complete."
