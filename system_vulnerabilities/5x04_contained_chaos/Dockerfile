FROM python:3.11-slim

# SECURITY: no secret is stored in this image.
# DB_HOST, DB_USER and DB_PASSWORD must be provided at runtime.
# Never define secrets with ENV, ARG or RUN: they stay visible
# in "docker history" and "docker inspect" for anyone with the image.
#
# Correct ways to pass secrets when starting the container:
#   docker run -e DB_HOST -e DB_USER -e DB_PASSWORD devstream-nosecrets:v1
#   docker run --env-file .env devstream-nosecrets:v1
#     (.env must be chmod 600 and never committed or copied into the image)
# In production, prefer a secret manager (Docker secrets, Vault)
# that mounts secrets as files under /run/secrets/.

RUN groupadd --gid 1000 appuser && \
    useradd --uid 1000 --gid appuser --no-create-home --shell /usr/sbin/nologin appuser

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

USER 1000:1000

EXPOSE 5000

CMD ["python", "app.py"]
