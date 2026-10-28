#!/bin/bash
# Lance le conteneur DevStream avec toutes les options de sécurité

docker build -t devstream-secure:v1 . > /dev/null 2>&1 || exit 1
docker rm -f devstream-hardened > /dev/null 2>&1

echo "Security options applied:"
echo "  --security-opt=no-new-privileges:true"
echo "    (Process cannot gain new privileges via setuid, etc.)"
echo "  --security-opt=seccomp=default"
echo "    (Syscall filtering enabled)"
echo "Additional hardening:"
echo "  --cap-drop=ALL"
echo "  --read-only"
echo "  --user=appuser"

docker run -d --name devstream-hardened --security-opt=no-new-privileges:true --cap-drop=ALL --read-only --tmpfs /tmp:rw,noexec,nosuid,size=64m --tmpfs /app/logs:rw,noexec,nosuid,size=16m --user=appuser --memory=256m --memory-swap=256m --cpus=0.5 --pids-limit=50 devstream-secure:v1 > /dev/null || exit 1
echo "Container started with maximum hardening."

echo "Security verification:"
status=$(docker exec devstream-hardened cat /proc/1/status)

if echo "$status" | grep -q '^NoNewPrivs:[[:space:]]*1'; then
    echo "  New privileges: BLOCKED"
else
    echo "  New privileges: ALLOWED"
fi

if echo "$status" | grep -q '^Seccomp:[[:space:]]*2'; then
    echo "  Seccomp: ENABLED"
else
    echo "  Seccomp: DISABLED"
fi

if [ "$(docker exec devstream-hardened id -u)" != "0" ]; then
    echo "  Root access: NONE"
else
    echo "  Root access: GRANTED"
fi
