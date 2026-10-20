#!/bin/bash
echo "=== Package Security Audit ==="
echo ""

dev_count=0
net_count=0
remote_count=0

# Fonction : vérifie si un paquet est installé et l'affiche
check_pkg() {
    local pkg="$1"
    local desc="$2"
    if dpkg -l "$pkg" 2>/dev/null | grep -q '^ii'; then
        echo "  [FOUND] $pkg ($desc)"
        return 0
    fi
    return 1
}

echo "Checking for development tools..."
check_pkg gcc "GNU C Compiler"    && dev_count=$((dev_count + 1))
check_pkg g++ "GNU C++ Compiler"  && dev_count=$((dev_count + 1))
check_pkg make "Build automation" && dev_count=$((dev_count + 1))
check_pkg gdb "Debugger"          && dev_count=$((dev_count + 1))

echo ""
echo "Checking for network tools..."
check_pkg netcat-openbsd "Network Swiss Army Knife" && net_count=$((net_count + 1))
check_pkg nmap "Network scanner"                    && net_count=$((net_count + 1))
check_pkg tcpdump "Packet capture"                  && net_count=$((net_count + 1))

echo ""
echo "Checking for remote access tools..."
check_pkg telnet "Insecure remote access" && remote_count=$((remote_count + 1))

echo ""
echo "Summary:"
echo "  Development tools: $dev_count found"
echo "  Network tools: $net_count found"
echo "  Remote access: $remote_count found"
echo ""
echo "Recommendation: Review and remove unnecessary packages."
