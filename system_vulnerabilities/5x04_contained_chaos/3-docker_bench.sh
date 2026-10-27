#!/bin/bash
# Lance docker-bench-security sur le conteneur vulnérable

docker rm -f devstream-vulnerable > /dev/null 2>&1
docker run -d --name devstream-vulnerable devstream-vulnerable:latest > /dev/null
if [ ! -d "$HOME/docker-bench-security" ]; then
    git clone -q https://github.com/docker/docker-bench-security.git "$HOME/docker-bench-security"
fi

echo "Running docker-bench-security..."

results=$(cd "$HOME/docker-bench-security" && sudo sh docker-bench-security.sh -b -c container_images,container_runtime | grep -E '^\[[A-Z]+\] [0-9]+\.[0-9]+ ' | sed -E 's/ \((Automated|Manual)\)$//')

echo "$results" | grep '\] 4\.'

echo "Container Runtime Checks:"
echo "$results" | grep '\] 5\.'
pass=$(echo "$results" | grep -c '^\[PASS\]')
warn=$(echo "$results" | grep -c '^\[WARN\]')
info=$(echo "$results" | grep -c '^\[INFO\]')
note=$(echo "$results" | grep -c '^\[NOTE\]')

echo "Summary:"
echo "  PASS: $pass"
echo "  WARN: $warn"
echo "  INFO: $info"
echo "  NOTE: $note"

score=$((pass * 100 / (pass + warn)))

if [ "$score" -lt 50 ]; then
    verdict="CRITICAL - Do not deploy"
elif [ "$score" -lt 80 ]; then
    verdict="WARNING - Hardening required"
else
    verdict="GOOD"
fi

echo "Score: $score% ($verdict)"
