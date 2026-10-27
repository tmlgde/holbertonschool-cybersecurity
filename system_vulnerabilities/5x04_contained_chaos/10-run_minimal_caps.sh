#!/bin/bash
# Lance le conteneur DevStream avec le minimum de capabilities

docker build -t devstream-secure:v1 . > /dev/null 2>&1 || exit 1
docker rm -f devstream-secure > /dev/null 2>&1

echo "Dropping all capabilities..."
echo "Adding back only required capabilities:"
echo "  (none needed for this application)"

echo "Starting container..."
docker run -d --name devstream-secure -p 5000:5000 --cap-drop=ALL devstream-secure:v1 > /dev/null || exit 1
echo "  Container: devstream-secure"
echo "  Capabilities: NONE"

echo "Verification:"
echo "  \$ docker exec devstream-secure cat /proc/1/status | grep Cap"
docker exec devstream-secure cat /proc/1/status | grep -E '^Cap(Prm|Eff|Bnd)' | sed 's/^/  /'

sleep 3
if curl -sf http://localhost:5000/health > /dev/null; then
    echo "Application status: Running normally ✓"
else
    echo "Application status: Not responding ✗"
fi

echo "The container has ZERO elevated capabilities."
echo "Even if compromised, the attacker's abilities are limited."
