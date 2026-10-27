#!/bin/bash
# Compare la taille de l'image single-stage et de l'image multi-stage

docker build -t devstream-multistage:v1 . > /dev/null 2>&1 || exit 1

single=$(docker image inspect --format '{{.Size}}' devstream-vulnerable:latest)
multi=$(docker image inspect --format '{{.Size}}' devstream-multistage:v1)

echo "Single-stage image: $((single / 1000 / 1000)) MB"
echo "Multi-stage image: $((multi / 1000 / 1000)) MB"
echo "Reduction: $(((single - multi) * 100 / single))%"

echo "Packages in final image:"
docker run --rm devstream-multistage:v1 python --version | sed 's/^/  /'
docker run --rm devstream-multistage:v1 pip list --format=freeze 2>/dev/null | grep -i '^flask==' | sed 's/^/  /'
echo "  (minimal runtime only)"

echo "Build tools excluded:"
for tool in gcc make; do
    if docker run --rm devstream-multistage:v1 sh -c "command -v $tool" > /dev/null; then
        echo "  $tool ✗"
    else
        echo "  $tool ✓"
    fi
done

if docker run --rm --user root devstream-multistage:v1 test -d /root/.cache/pip; then
    echo "  pip (caches cleared) ✗"
else
    echo "  pip (caches cleared) ✓"
fi
