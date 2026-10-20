#!/bin/bash
echo "=== Enabling Reverse Path Filtering ==="
echo ""

CONF="/etc/sysctl.d/99-hardening.conf"
sudo touch "$CONF"

params="net.ipv4.conf.all.rp_filter net.ipv4.conf.default.rp_filter"

echo "Setting strict mode (1) for all interfaces..."
for param in $params; do
    sudo sysctl -w "$param=1" >/dev/null
    sudo sed -i "\|$param|d" "$CONF"
    echo "$param = 1" | sudo tee -a "$CONF" >/dev/null
    echo "  $param = 1"
done

echo ""
echo "Configuration saved to $CONF"
echo ""
echo "Reverse path filtering: STRICT MODE"
echo "Spoofed packets will be dropped."
