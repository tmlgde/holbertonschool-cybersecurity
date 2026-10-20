#!/bin/bash
echo ""
echo "Running Lynis audit..."
echo ""

# Lancer l'audit Lynis
sudo lynis audit system --quiet > /dev/null 2>&1

REPORT="/var/log/lynis-report.dat"

# Extraire les métriques
hardening=$(sudo grep '^hardening_index=' "$REPORT" | cut -d= -f2)
tests=$(sudo grep '^lynis_tests_done=' "$REPORT" | cut -d= -f2)
warnings=$(sudo grep -c '^warning\[\]=' "$REPORT")
suggestions=$(sudo grep -c '^suggestion\[\]=' "$REPORT")

# Construire la barre de progression (20 caractères)
filled=$(( hardening / 5 ))
empty=$(( 20 - filled ))
bar=""
for ((i=0; i<filled; i++)); do bar="${bar}#"; done
for ((i=0; i<empty; i++)); do bar="${bar}."; done

echo "Hardening Index: $hardening [$bar]"
echo "Tests Performed: $tests"
echo "Warnings: $warnings"
echo "Suggestions: $suggestions"

# Findings critiques (les warnings)
echo ""
echo "Critical Findings:"
sudo grep '^warning\[\]=' "$REPORT" | cut -d= -f2 | cut -d'|' -f2 | head -5 | sed 's/^/  [WARNING] /'

# Sauvegarde de la baseline
echo ""
sudo mkdir -p /var/log/hardening
BASELINE="/var/log/hardening/baseline-$(date +%Y%m%d).txt"
sudo cp "$REPORT" "$BASELINE"
echo "Baseline saved to: $BASELINE"
