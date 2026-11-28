#!/bin/bash
rubric="ICS MGMT certificate secret breach reputation Year score exposure host"
d="$(dirname "$0")"
cerebra_score=0; yume_score=0; verdant_score=0
[ -s "$d/1-flag.txt" ] && cerebra_score=$((cerebra_score+1))
[ -s "$d/2-flag.txt" ] && yume_score=$((yume_score+2))
grep -q 'ICS'  "$d/3-flag.txt" 2>/dev/null && cerebra_score=$((cerebra_score+4))
grep -q 'MGMT' "$d/3-flag.txt" 2>/dev/null && yume_score=$((yume_score+3))
[ -s "$d/4-flag.txt" ] && yume_score=$((yume_score+2))
[ -s "$d/5-flag.txt" ] && verdant_score=$((verdant_score+1))
[ -s "$d/6-flag.txt" ] && cerebra_score=$((cerebra_score+2))
[ -s "$d/7-flag.txt" ] && verdant_score=$((verdant_score+1))
[ -s "$d/8-flag.txt" ] && cerebra_score=$((cerebra_score+1))
grep -qiE 'APIKEY|TOKEN|PASSWORD|PRIVATEKEY' "$d/9-flag.txt" 2>/dev/null && yume_score=$((yume_score+3))
grep -qE '[0-9]{4}' "$d/10-flag.txt" 2>/dev/null && cerebra_score=$((cerebra_score+3))
top=Cerebra; max=$cerebra_score
[ "$yume_score" -gt "$max" ] && { top=Yume; max=$yume_score; }
[ "$verdant_score" -gt "$max" ] && { top=Verdant; max=$verdant_score; }
echo "$top"
echo "cerebra.lab:47808"
