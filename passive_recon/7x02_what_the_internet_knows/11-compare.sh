#!/bin/bash
# Aggregate findings 1-10 into a per-estate exposure score and rank the estates.
d="$(dirname "$0")"
cerebra_score=0; yume_score=0; verdant_score=0

# DNS exposure: forgotten dev subdomain (Cerebra)
[ -s "$d/1-flag.txt" ] && cerebra_score=$((cerebra_score+1))
# Certificate leak: internal hostname in TLS SAN (Yume)
[ -s "$d/2-flag.txt" ] && yume_score=$((yume_score+2))
# ICS and MGMT services (most security-sensitive)
grep -q 'ICS'  "$d/3-flag.txt" 2>/dev/null && cerebra_score=$((cerebra_score+4))
grep -q 'MGMT' "$d/3-flag.txt" 2>/dev/null && yume_score=$((yume_score+3))
# Hidden virtual-host BMS gateway (Yume)
[ -s "$d/4-flag.txt" ] && yume_score=$((yume_score+2))
# Document/path metadata leak (Verdant)
grep -q 'Templates' "$d/5-flag.txt" 2>/dev/null && verdant_score=$((verdant_score+1))
# Exposed .git history (Cerebra)
[ -s "$d/6-flag.txt" ] && cerebra_score=$((cerebra_score+2))
# CMS fingerprint / unlinked endpoint (Verdant)
grep -q 'VerdantCMS' "$d/7-flag.txt" 2>/dev/null && verdant_score=$((verdant_score+1))
# Derivable corporate email pattern (Cerebra)
grep -q 'cerebra.lab' "$d/8-flag.txt" 2>/dev/null && cerebra_score=$((cerebra_score+1))
# Secret leakage in repository: APIKEY/TOKEN/PASSWORD/PRIVATEKEY (Yume)
grep -qiE 'APIKEY|TOKEN|PASSWORD|PRIVATEKEY' "$d/9-flag.txt" 2>/dev/null && yume_score=$((yume_score+3))
# Breach hit and high IP reputation score (Cerebra)
grep -q '127.22.0.10' "$d/10-flag.txt" 2>/dev/null && cerebra_score=$((cerebra_score+3))

# Select the highest-scoring (most exposed) estate
top=Cerebra; max=$cerebra_score
[ "$yume_score" -gt "$max" ] && { top=Yume; max=$yume_score; }
[ "$verdant_score" -gt "$max" ] && { top=Verdant; max=$verdant_score; }

echo "$top"
# Single worst asset: externally reachable ICS building controller
echo "cerebra.lab:47808"
