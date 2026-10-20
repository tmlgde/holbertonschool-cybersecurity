#!/bin/bash
echo "=== Network Tools Restriction ==="
echo ""

echo "Restricting access (root only)..."

restrict_tool() {
    local tool="$1"
    if [ -f "$tool" ]; then
        local old=$(stat -c '%a' "$tool")
        sudo chmod 0750 "$tool"
        echo "  $tool: 0750 (was 0$old)"
    fi
}

restrict_tool /usr/bin/nc
restrict_tool /usr/bin/ncat
restrict_tool /usr/bin/nmap
restrict_tool /usr/bin/tcpdump
restrict_tool /usr/sbin/tcpdump

echo ""
echo "Verification:"
for tool in /usr/bin/nc /usr/bin/ncat /usr/bin/nmap /usr/bin/tcpdump /usr/sbin/tcpdump; do
    if [ -f "$tool" ]; then
        echo "  $(basename $tool): $(ls -l $tool | awk '{print $1, $3, $4}')"
    fi
done

echo ""
echo "Network tools restricted to root."
echo "Regular users can no longer execute these binaries."
