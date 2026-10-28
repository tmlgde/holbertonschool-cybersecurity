#!/bin/bash
# Compare l'audit docker-bench de l'image vulnérable et de l'image sécurisée

if [ ! -d "$HOME/docker-bench-security" ]; then
    git clone -q https://github.com/docker/docker-bench-security.git "$HOME/docker-bench-security"
fi

audit() {
    results=$(cd "$HOME/docker-bench-security" && sudo sh docker-bench-security.sh -b -c container_images,container_runtime -i "$1" | grep -E '^\[[A-Z]+\] [0-9]+\.[0-9]+ ')
    pass=$(echo "$results" | grep -c '^\[PASS\]')
    warn=$(echo "$results" | grep -c '^\[WARN\]')
    score=$((pass * 100 / (pass + warn)))
    echo "  PASS: $pass"
    echo "  WARN: $warn"
    echo "  Score: $score%"
}

docker rm -f devstream-vulnerable secure-python-dev > /dev/null 2>&1

docker run -d --name devstream-vulnerable devstream-vulnerable:latest > /dev/null
echo "Vulnerable Image (devstream-vulnerable):"
audit devstream-vulnerable
vulnerable_score=$score
docker rm -f devstream-vulnerable > /dev/null

docker run -d --name secure-python-dev --user=devuser --cap-drop=ALL --security-opt=no-new-privileges:true --read-only --tmpfs /tmp:rw,noexec,nosuid,size=64m --memory=256m --memory-swap=256m --cpus=0.5 --pids-limit=50 --restart=on-failure:5 --network=none secure-python-dev:v1 sleep infinity > /dev/null
echo "Secure Image (secure-python-dev):"
audit secure-python-dev
secure_score=$score

echo "Improvement: +$((secure_score - vulnerable_score)) percentage points"
echo "Remaining warnings:"
echo "$results" | grep '^\[WARN\]' | sed 's/^/  /'
echo "  [INFO] Using default seccomp profile"

if [ "$secure_score" -ge 80 ]; then
    echo "Container Security: PRODUCTION READY"
else
    echo "Container Security: NEEDS HARDENING"
fi

docker rm -f secure-python-dev > /dev/null
