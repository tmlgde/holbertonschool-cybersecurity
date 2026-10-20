#!/bin/bash
echo "=== Disabling IP Forwarding ==="
echo ""

CONF="/etc/sysctl.d/99-hardening.conf"

# État actuel
echo "Current state:"
echo "  net.ipv4.ip_forward = $(sysctl -n net.ipv4.ip_forward)"
echo "  net.ipv6.conf.all.forwarding = $(sysctl -n net.ipv6.conf.all.forwarding)"

# Appliquer à chaud
echo ""
echo "Applying changes..."
sudo sysctl -w net.ipv4.ip_forward=0 >/dev/null
sudo sysctl -w net.ipv6.conf.all.forwarding=0 >/dev/null
echo "  net.ipv4.ip_forward = 0"
echo "  net.ipv6.conf.all.forwarding = 0"

# Rendre persistant (idempotent : on retire les anciennes lignes avant d'ajouter)
echo ""
echo "Making persistent in $CONF..."
sudo touch "$CONF"
sudo sed -i '/net.ipv4.ip_forward/d; /net.ipv6.conf.all.forwarding/d' "$CONF"
echo "net.ipv4.ip_forward = 0" | sudo tee -a "$CONF" >/dev/null
echo "net.ipv6.conf.all.forwarding = 0" | sudo tee -a "$CONF" >/dev/null

# Vérification
echo ""
echo "Verification:"
if [ "$(sysctl -n net.ipv4.ip_forward)" -eq 0 ]; then
    echo "  IPv4 forwarding: DISABLED"
else
    echo "  IPv4 forwarding: ENABLED"
fi
if [ "$(sysctl -n net.ipv6.conf.all.forwarding)" -eq 0 ]; then
    echo "  IPv6 forwarding: DISABLED"
else
    echo "  IPv6 forwarding: ENABLED"
fi
