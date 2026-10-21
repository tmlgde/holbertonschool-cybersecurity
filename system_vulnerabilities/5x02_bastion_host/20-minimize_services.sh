#!/bin/bash
echo "=== Service Minimization ==="
echo ""
echo "Checking for unnecessary services..."
echo ""

# Services inutiles (nom:description)
echo "Unnecessary services found:"

disable_service() {
    local svc="$1"
    local desc="$2"
    if systemctl list-unit-files 2>/dev/null | grep -q "^${svc}"; then
        echo "  ${svc} (${desc}) - Not needed on web server"
    fi
}

disable_service cups.service "Printing"
disable_service avahi-daemon.service "mDNS"
disable_service bluetooth.service "Bluetooth"

echo ""
echo "Disabling services..."
for svc in cups.service avahi-daemon.service bluetooth.service; do
    if systemctl list-unit-files 2>/dev/null | grep -q "^${svc}"; then
        sudo systemctl stop "$svc" 2>/dev/null
        sudo systemctl disable "$svc" 2>/dev/null
        echo "  ${svc}: Disabled and stopped"
    fi
done

echo ""
echo "Essential services preserved:"
for svc in ssh.service apache2.service; do
    if systemctl is-active "$svc" >/dev/null 2>&1; then
        echo "  ${svc}: Running ✓"
    fi
done

echo ""
echo "Services reduced. Attack surface minimized."
