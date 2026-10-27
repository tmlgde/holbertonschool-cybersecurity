#!/bin/bash
# Construit et analyse l'image vulnérable de DevStream

echo "Creating application files..."

cat > app.py << 'EOF'
from flask import Flask
import os

app = Flask(__name__)

@app.route('/')
def hello():
    return f"Hello from DevStream! DB: {os.environ.get('DB_HOST', 'unknown')}"

@app.route('/health')
def health():
    return "OK", 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
EOF
echo "  app.py: Created"

cat > requirements.txt << 'EOF'
flask==3.0.0
EOF
echo "  requirements.txt: Created"

cat > Dockerfile << 'EOF'
# DevStream's "production" Dockerfile
# DO NOT USE IN PRODUCTION (but they did...)

FROM ubuntu:latest

# Install everything we might need
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    curl \
    wget \
    vim \
    net-tools \
    iputils-ping \
    gcc \
    make \
    sudo

# Set root password (for debugging)
RUN echo 'root:devstream123' | chpasswd

# Database credentials
ENV DB_HOST=prod-db.devstream.internal
ENV DB_USER=admin
ENV DB_PASSWORD=Sup3rS3cr3t!Pr0d

# Copy application
WORKDIR /app
COPY . /app

# Install Python dependencies
RUN pip3 install --break-system-packages -r requirements.txt

# Run as root because it's easier
EXPOSE 5000

CMD ["python3", "app.py"]
EOF
echo "  Dockerfile: Created"

echo "Building image..."
echo "  Image: devstream-vulnerable:latest"

if docker build -t devstream-vulnerable:latest . > /dev/null 2>&1; then
    echo "  Build: SUCCESS"
else
    echo "  Build: FAILED"
    exit 1
fi

echo "Image Analysis:"

size=$(docker image inspect --format '{{.Size}}' devstream-vulnerable:latest)
echo "  Size: $((size / 1000 / 1000)) MB"

echo "  Base: $(grep '^FROM' Dockerfile | cut -d' ' -f2)"

docker run --rm devstream-vulnerable:latest sh -c 'echo "  User: $(whoami) (UID $(id -u))"'

echo "Environment Variables (EXPOSED SECRETS):"
docker image inspect --format '{{range .Config.Env}}{{println .}}{{end}}' devstream-vulnerable:latest | grep '^DB_' | sed 's/^/  /'

echo "WARNING: This image contains hardcoded credentials!"
