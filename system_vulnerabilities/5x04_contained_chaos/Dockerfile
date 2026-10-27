# Stage 1: builder - build tools are used here only and never reach the final image
FROM python:3.11-slim AS builder

RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc make && \
    rm -rf /var/lib/apt/lists/*

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

WORKDIR /build
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2: runtime - only what is needed to run the application
FROM python:3.11-slim

# SECURITY: no secret is stored in this image.
# DB_HOST, DB_USER and DB_PASSWORD must be provided at runtime.
# Never define secrets with ENV, ARG or RUN: they stay visible
# in "docker history" and "docker inspect" for anyone with the image.
#
# Correct ways to pass secrets when starting the container:
#   docker run -e DB_HOST -e DB_USER -e DB_PASSWORD devstream-multistage:v1
#   docker run --env-file .env devstream-multistage:v1
#     (.env must be chmod 600 and never committed or copied into the image)
# In production, prefer a secret manager (Docker secrets, Vault)
# that mounts secrets as files under /run/secrets/.

RUN groupadd --gid 1000 appuser && \
    useradd --uid 1000 --gid appuser --no-create-home --shell /usr/sbin/nologin appuser
# curl is only needed by the HEALTHCHECK below
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl && \
    rm -rf /var/lib/apt/lists/*
COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

WORKDIR /app
COPY app.py .

USER 1000:1000

HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD curl -f http://localhost:5000/health || exit 1

EXPOSE 5000

CMD ["python", "app.py"]
