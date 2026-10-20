#!/bin/bash
echo "=== Enabling SYN Cookies ==="
echo ""

CONF="/etc/sysctl.d/99-hardening.conf"
sudo touch "$CONF"

# État actuel
echo "Current state:"
echo "  net.ipv4.tcp_syncookies = $(sysctl -n net.ipv4.tcp_syncookies)"

# Activer à chaud
echo ""
echo "Enabling SYN cookies..."
sudo sysctl -w net.ipv4.tcp_syncookies=1 >/dev/null
echo "  net.ipv4.tcp_syncookies = 1"

# Persistance (idempotent)
sudo sed -i "\|net.ipv4.tcp_syncookies|d" "$CONF"
echo "net.ipv4.tcp_syncookies = 1" | sudo tee -a "$CONF" >/dev/null

echo ""
echo "Configuration saved to $CONF"
echo ""
echo "SYN flood protection: ENABLED"
