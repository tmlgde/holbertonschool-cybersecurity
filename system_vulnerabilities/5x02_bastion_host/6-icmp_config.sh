#!/bin/bash
echo "=== ICMP Configuration ==="
echo ""

CONF="/etc/sysctl.d/99-hardening.conf"
sudo touch "$CONF"

# Fonction-maison pour appliquer + persister un paramètre
apply_param() {
    local param="$1"
    local value="$2"
    sudo sysctl -w "$param=$value" >/dev/null
    sudo sed -i "\|$param|d" "$CONF"
    echo "$param = $value" | sudo tee -a "$CONF" >/dev/null
}

echo "Disabling broadcast ping response (Smurf prevention)..."
apply_param net.ipv4.icmp_echo_ignore_broadcasts 1
echo "  net.ipv4.icmp_echo_ignore_broadcasts = 1"

echo ""
echo "Keeping unicast ping enabled for diagnostics."
apply_param net.ipv4.icmp_echo_ignore_all 0
echo "  net.ipv4.icmp_echo_ignore_all = 0"

echo ""
echo "Ignoring bogus ICMP error responses..."
apply_param net.ipv4.icmp_ignore_bogus_error_responses 1
echo "  net.ipv4.icmp_ignore_bogus_error_responses = 1"

echo ""
echo "Configuration saved to $CONF"
echo ""
echo "Broadcast ping: DISABLED"
echo "Unicast ping: ENABLED"
