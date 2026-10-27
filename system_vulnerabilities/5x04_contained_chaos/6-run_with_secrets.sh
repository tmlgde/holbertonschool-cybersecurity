#!/bin/bash
# Lance le conteneur DevStream avec les secrets fournis au runtime

echo "Building devstream-nosecrets:v1..."
docker build -t devstream-nosecrets:v1 . > /dev/null 2>&1 || exit 1

echo "Starting container with runtime secrets..."
docker rm -f devstream-nosecrets > /dev/null 2>&1
docker run -d --name devstream-nosecrets -p 5000:5000 -e DB_HOST -e DB_USER -e DB_PASSWORD devstream-nosecrets:v1 > /dev/null

sleep 3

echo "Secrets in image:"
docker image inspect --format '{{range .Config.Env}}{{println .}}{{end}}' devstream-nosecrets:v1 | grep '^DB_' || echo "  none"

echo "Secrets in container:"
docker exec devstream-nosecrets env | grep '^DB_' | cut -d'=' -f1 | sed 's/^/  /'

echo "Application response:"
curl -s http://localhost:5000/
echo
