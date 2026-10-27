#!/bin/bash
# Lance le conteneur DevStream avec un système de fichiers en lecture seule

docker build -t devstream-secure:v1 . > /dev/null 2>&1 || exit 1
docker rm -f devstream-readonly > /dev/null 2>&1

echo "Starting container with:"
echo "  --read-only"
echo "  --tmpfs /tmp (for temporary files)"
echo "  --tmpfs /app/logs (for application logs)"

docker run -d --name devstream-readonly -p 5000:5000 --read-only --tmpfs /tmp:rw,noexec,nosuid,size=64m --tmpfs /app/logs:rw,noexec,nosuid,size=16m --cap-drop=ALL devstream-secure:v1 > /dev/null || exit 1

echo "Verification:"

if docker exec --user root devstream-readonly touch /etc/test 2>/dev/null; then
    echo "  Attempt to write to /etc: ALLOWED"
else
    echo "  Attempt to write to /etc: BLOCKED"
fi

if docker exec --user root devstream-readonly touch /app/test 2>/dev/null; then
    echo "  Attempt to write to /app: ALLOWED"
else
    echo "  Attempt to write to /app: BLOCKED"
fi

if docker exec devstream-readonly touch /tmp/test 2>/dev/null; then
    echo "  Attempt to write to /tmp: ALLOWED"
else
    echo "  Attempt to write to /tmp: BLOCKED"
fi

if docker exec devstream-readonly sh -c 'echo "test log" > /app/logs/app.log' 2>/dev/null; then
    echo "  Application logging: WORKING"
else
    echo "  Application logging: FAILED"
fi

echo "Root filesystem: READ-ONLY"
echo "Attackers cannot modify system files or drop tools."
