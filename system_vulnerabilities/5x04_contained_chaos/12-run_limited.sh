#!/bin/bash
# Lance le conteneur DevStream avec des limites de ressources

docker build -t devstream-secure:v1 . > /dev/null 2>&1 || exit 1
docker rm -f devstream-limited > /dev/null 2>&1

echo "Applying limits:"
echo "  --memory=256m (max 256MB RAM)"
echo "  --memory-swap=256m (no swap)"
echo "  --cpus=0.5 (max 50% of one CPU)"
echo "  --pids-limit=50 (max 50 processes)"

docker run -d --name devstream-limited --memory=256m --memory-swap=256m --cpus=0.5 --pids-limit=50 --read-only --tmpfs /tmp:rw,noexec,nosuid,size=64m --tmpfs /app/logs:rw,noexec,nosuid,size=16m --cap-drop=ALL devstream-secure:v1 > /dev/null || exit 1
echo "Container started: devstream-limited"

echo "Verification:"
memory=$(docker inspect --format '{{.HostConfig.Memory}}' devstream-limited)
cpus=$(docker inspect --format '{{.HostConfig.NanoCpus}}' devstream-limited)
pids=$(docker inspect --format '{{.HostConfig.PidsLimit}}' devstream-limited)

echo "  Memory limit: $((memory / 1024 / 1024))MB"
echo "  CPU limit: $(awk "BEGIN {print $cpus / 1000000000}") cores"
echo "  PID limit: $pids"

echo "Resource limits active."
echo "Container cannot exhaust host resources."
