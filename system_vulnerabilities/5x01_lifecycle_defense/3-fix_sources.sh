#!/bin/bash
echo "=== APT Sources Validation ==="
echo ""

valid=0
disabled=0

echo "Checking sources.list.d/..."
for src in /etc/apt/sources.list.d/*.list; do
    [ -f "$src" ] || continue
    url=$(awk '/^deb / {print $2}' "$src" | head -1)
    if [ -z "$url" ]; then
        continue
    fi
    if curl -s --head --max-time 5 "$url" >/dev/null 2>&1; then
        valid=$((valid + 1))
    else
        echo "  $(basename "$src"): INVALID (repository not reachable)"
        sudo mv "$src" "${src}.disabled"
        echo "    Action: Renamed to $(basename "$src").disabled"
        disabled=$((disabled + 1))
    fi
done

echo ""
echo "Running apt update..."
if sudo apt-get update >/dev/null 2>&1; then
    echo "  All repositories updated successfully."
else
    echo "  Some repositories could not be updated."
fi

echo ""
echo "Summary:"
echo "  Valid sources: $valid"
echo "  Disabled sources: $disabled"
