#!/bin/bash
echo "=== Blocking Source Routing ==="
echo ""

CONF="/etc/sysctl.d/99-hardening.conf"
sudo touch "$CONF"

params="net.ipv4.conf.all.accept_source_route net.ipv4.conf.default.accept_source_route net.ipv6.conf.all.accept_source_route net.ipv6.conf.default.accept_source_route"

echo "Disabling source route acceptance..."
for param in $params; do
    sudo sysctl -w "$param=0" >/dev/null
    sudo sed -i "\|$param|d" "$CONF"
    echo "$param = 0" | sudo tee -a "$CONF" >/dev/null
    echo "  $param = 0"
done

echo ""
echo "Configuration saved to $CONF"
echo ""
echo "Source-routed packets: BLOCKED"
