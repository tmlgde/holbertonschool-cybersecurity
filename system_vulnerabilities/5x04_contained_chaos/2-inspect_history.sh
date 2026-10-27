#!/bin/bash
# Extrait les secrets de l'historique d'une image Docker

image="$1"

echo "Image: $image"

echo "Layer History:"
echo "  Layer 1: $(grep '^FROM' Dockerfile)"

n=1
docker history --no-trunc --format '{{.Comment}}|{{.CreatedBy}}' "$image" | grep '^buildkit' | cut -d'|' -f2- | tac | sed -e 's|/bin/sh -c ||' -e 's| # buildkit||' | while read -r line; do
    n=$((n + 1))
    case "$line" in
        *chpasswd*) echo "  Layer $n: $line  ← PASSWORD EXPOSED" ;;
        *DB_PASSWORD*) echo "  Layer $n: $line  ← SECRET EXPOSED" ;;
        *) echo "  Layer $n: $line" ;;
    esac
done
echo "Extracting secrets from history..."

history=$(docker history --no-trunc --format '{{.CreatedBy}}' "$image")

root_pass=$(echo "$history" | grep 'chpasswd' | cut -d"'" -f2 | cut -d':' -f2)
db_pass=$(echo "$history" | grep 'DB_PASSWORD=' | cut -d'=' -f2-)

echo "  Root password: $root_pass"
echo "  DB Password: $db_pass"

echo "CRITICAL: All ENV and RUN commands are permanently"
echo "visible in image layers. Never put secrets here!"
