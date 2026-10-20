#!/bin/bash
echo "=== Living off the Land Binaries Audit ==="
echo ""
echo "Checking GTFOBins candidates..."

# Fonction : affiche le binaire avec ses permissions et une annotation
audit_bin() {
    local bin="$1"
    local note="$2"
    if [ -f "$bin" ]; then
        local perms=$(ls -l "$bin" | awk '{print $1}')
        echo "  $bin: $perms ($note)"
    fi
}

echo ""
echo "File Readers (can read sensitive files):"
audit_bin /usr/bin/cat "OK"
audit_bin /usr/bin/less "OK"
audit_bin /usr/bin/vim "WARNING: Can escape to shell"

echo ""
echo "Shell Escapes:"
audit_bin /usr/bin/python3 "WARNING: Can spawn shells"
audit_bin /usr/bin/perl "WARNING: Can spawn shells"
audit_bin /usr/bin/awk "OK"

echo ""
echo "Network Tools:"
audit_bin /usr/bin/wget "WARNING: Can download payloads"
audit_bin /usr/bin/curl "WARNING: Can download payloads"

echo ""
echo "Note: These binaries are legitimate but should be monitored."
echo "See https://gtfobins.github.io/ for abuse techniques."
