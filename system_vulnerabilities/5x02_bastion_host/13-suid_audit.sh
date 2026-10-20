#!/bin/bash
echo "=== SUID/SGID Binary Audit ==="
echo ""

REPORT="/var/log/hardening/suid_audit.txt"
sudo mkdir -p /var/log/hardening

# Liste blanche des SUID connus sûrs
known_safe="sudo passwd chsh chfn su gpasswd"

suid_count=0
sgid_count=0
unknown_count=0

# Fonction de catégorisation
categorize() {
    local file="$1"
    local name=$(basename "$file")
    # Lieu non-standard = haut risque
    if echo "$file" | grep -qE '/usr/local/|/opt/|/home/|/tmp/'; then
        echo "UNKNOWN - HIGH RISK"
        return 2
    fi
    # Dans la liste blanche ?
    for safe in $known_safe; do
        if [ "$name" = "$safe" ]; then
            echo "KNOWN SAFE"
            return 0
        fi
    done
    echo "REVIEW NEEDED"
    return 1
}

echo "SUID binaries (run as owner):"
for file in $(find / -perm -4000 -type f 2>/dev/null); do
    owner=$(stat -c '%U' "$file")
    category=$(categorize "$file")
    printf "  %-30s %-8s %s\n" "$file" "$owner" "$category"
    suid_count=$((suid_count + 1))
    if [ "$category" = "UNKNOWN - HIGH RISK" ]; then
        unknown_count=$((unknown_count + 1))
    fi
done

echo ""
echo "SGID binaries (run as group):"
for file in $(find / -perm -2000 -type f 2>/dev/null); do
    group=$(stat -c '%G' "$file")
    printf "  %-30s %-8s %s\n" "$file" "$group" "REVIEW NEEDED"
    sgid_count=$((sgid_count + 1))
done

echo ""
echo "Summary:"
echo "  Total SUID: $suid_count"
echo "  Total SGID: $sgid_count"
echo "  Unknown/Custom: $unknown_count (requires investigation)"

# Sauvegarde du rapport
{
    echo "SUID/SGID Audit - $(date)"
    find / -perm -4000 -type f 2>/dev/null
    find / -perm -2000 -type f 2>/dev/null
} | sudo tee "$REPORT" >/dev/null

echo ""
echo "Full report saved to: $REPORT"
