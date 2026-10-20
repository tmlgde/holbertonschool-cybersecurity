#!/bin/bash
echo "=== Kernel Hardening Verification ==="
echo ""

passed=0
total=0

check_param() {
    local param="$1"
    local expected="$2"
    local actual=$(sysctl -n "$param" 2>/dev/null)
    if [ "$actual" = "$expected" ]; then
        echo "  [PASS] $param = $expected"
        passed=$((passed + 1))
    else
        echo "  [FAIL] $param = $actual (expected $expected)"
    fi
    total=$((total + 1))
}

echo "IP Forwarding:"
check_param net.ipv4.ip_forward 0
check_param net.ipv6.conf.all.forwarding 0

echo ""
echo "ICMP Redirects:"
check_param net.ipv4.conf.all.accept_redirects 0
check_param net.ipv4.conf.all.send_redirects 0

echo ""
echo "Reverse Path Filtering:"
check_param net.ipv4.conf.all.rp_filter 1

echo ""
echo "SYN Cookies:"
check_param net.ipv4.tcp_syncookies 1

echo ""
echo "Source Routing:"
check_param net.ipv4.conf.all.accept_source_route 0

echo ""
echo "ICMP Configuration:"
check_param net.ipv4.icmp_echo_ignore_broadcasts 1

echo ""
echo "Persistence Check:"
if [ -f /etc/sysctl.d/99-hardening.conf ]; then
    echo "  [PASS] /etc/sysctl.d/99-hardening.conf exists"
    passed=$((passed + 1))
else
    echo "  [FAIL] /etc/sysctl.d/99-hardening.conf missing"
fi
total=$((total + 1))

echo ""
echo "Summary: $passed/$total checks passed"
if [ "$passed" -eq "$total" ]; then
    echo "Kernel hardening: COMPLETE"
else
    echo "Kernel hardening: INCOMPLETE"
fi
