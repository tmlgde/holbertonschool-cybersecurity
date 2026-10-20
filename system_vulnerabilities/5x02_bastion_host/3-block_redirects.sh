#!/bin/bash
echo "=== Blocking ICMP Redirects ==="
echo ""

CONF="/etc/sysctl.d/99-hardening.conf"
sudo touch "$CONF"

# Les paramètres "accept_redirects" (ne pas accepter)
accept_params="net.ipv4.conf.all.accept_redirects net.ipv4.conf.default.accept_redirects net.ipv6.conf.all.accept_redirects net.ipv6.conf.default.accept_redirects"

# Les paramètres "send_redirects" (ne pas envoyer)
send_params="net.ipv4.conf.all.send_redirects net.ipv4.conf.default.send_redirects"

echo "Disabling redirect acceptance..."
for param in $accept_params; do
    sudo sysctl -w "$param=0" >/dev/null
    sudo sed -i "\|$param|d" "$CONF"
    echo "$param = 0" | sudo tee -a "$CONF" >/dev/null
    echo "  $param = 0"
done

echo ""
echo "Disabling redirect sending..."
for param in $send_params; do
    sudo sysctl -w "$param=0" >/dev/null
    sudo sed -i "\|$param|d" "$CONF"
    echo "$param = 0" | sudo tee -a "$CONF" >/dev/null
    echo "  $param = 0"
done

echo ""
echo "Configuration saved to $CONF"
echo ""
echo "ICMP redirects: BLOCKED"
