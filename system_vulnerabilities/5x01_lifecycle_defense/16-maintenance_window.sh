#!/bin/bash
echo "=== Maintenance Window Configuration ==="
echo ""
echo "Configuring systemd timer overrides..."
echo ""

# Créer les dossiers d'override
sudo mkdir -p /etc/systemd/system/apt-daily.timer.d
sudo mkdir -p /etc/systemd/system/apt-daily-upgrade.timer.d

# Override pour apt-daily.timer (mise à jour de la liste : 02:00)
sudo tee /etc/systemd/system/apt-daily.timer.d/override.conf > /dev/null <<'EOF'
[Timer]
OnCalendar=
OnCalendar=*-*-* 02:00
RandomizedDelaySec=30min
EOF

echo "apt-daily.timer:"
echo "  OnCalendar: *-*-* 02:00"
echo "  RandomizedDelaySec: 30min"
echo ""

# Override pour apt-daily-upgrade.timer (installation : 03:00)
sudo tee /etc/systemd/system/apt-daily-upgrade.timer.d/override.conf > /dev/null <<'EOF'
[Timer]
OnCalendar=
OnCalendar=*-*-* 03:00
RandomizedDelaySec=60min
EOF

echo "apt-daily-upgrade.timer:"
echo "  OnCalendar: *-*-* 03:00"
echo "  RandomizedDelaySec: 60min"
echo ""

echo "Timer configuration:"
echo "  Package list update: 02:00-02:30"
echo "  Package installation: 03:00-04:00"
echo ""

# Recharger systemd pour appliquer
echo "Reloading systemd..."
sudo systemctl daemon-reload

echo "Maintenance window configured."
