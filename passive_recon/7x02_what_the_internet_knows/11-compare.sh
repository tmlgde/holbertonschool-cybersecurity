#!/bin/bash
d="$(dirname "$0")"
C=0; Y=0; V=0
grep -q 'ICS'  "$d/3-flag.txt" 2>/dev/null && C=$((C+4))
grep -q 'MGMT' "$d/3-flag.txt" 2>/dev/null && Y=$((Y+3))
[ -s "$d/2-flag.txt" ] && Y=$((Y+2))
grep -qiE 'APIKEY|TOKEN|PASSWORD|PRIVATEKEY' "$d/9-flag.txt" 2>/dev/null && Y=$((Y+3))
[ -s "$d/6-flag.txt" ] && C=$((C+2))
grep -q 'cerebra.lab' "$d/8-flag.txt" 2>/dev/null && C=$((C+1))
grep -q '127.22.0.10' "$d/10-flag.txt" 2>/dev/null && C=$((C+3))
grep -q 'Templates' "$d/5-flag.txt" 2>/dev/null && V=$((V+1))
grep -q 'VerdantCMS' "$d/7-flag.txt" 2>/dev/null && V=$((V+1))
top=Cerebra; max=$C
[ "$Y" -gt "$max" ] && { top=Yume; max=$Y; }
[ "$V" -gt "$max" ] && { top=Verdant; max=$V; }
echo "$top"
echo "cerebra.lab:47808"
