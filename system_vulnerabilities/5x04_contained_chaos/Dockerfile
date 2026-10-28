# Stage 1: builder - install the Python tools in an isolated virtual environment
FROM python:3.11-slim AS builder

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

RUN pip install --no-cache-dir \
    pylint==3.3.1 \
    black==24.10.0 \
    pytest==8.3.3 \
    mypy==1.13.0

# Stage 2: runtime - secure Python 3.11 development environment
FROM python:3.11-slim

LABEL org.opencontainers.image.title="secure-python-dev" \
      org.opencontainers.image.description="Hardened Python 3.11 development environment" \
      org.opencontainers.image.version="1.0.0" \
      org.opencontainers.image.authors="DevStream Security Team" \
      org.opencontainers.image.licenses="MIT"

# SECURITY: no secret is stored in this image.
# Provide secrets at runtime only, for example:
#   docker run --env-file .env secure-python-dev:v1
#     (.env must be chmod 600 and never committed or copied into the image)
#
# Recommended hardened run command:
#   docker run -it --rm --cap-drop=ALL --security-opt=no-new-privileges:true
#     --read-only --tmpfs /tmp:rw,noexec,nosuid,size=256m
#     --tmpfs /home/devuser:rw,nosuid,size=256m
#     --memory=1g --cpus=2 --pids-limit=200
#     -v "$PWD":/workspace secure-python-dev:v1

ENV PATH="/opt/venv/bin:$PATH" \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

RUN groupadd --gid 1000 devuser && \
    useradd --uid 1000 --gid devuser --create-home --shell /bin/bash devuser && \
    mkdir /workspace && \
    chown devuser:devuser /workspace

COPY --from=builder /opt/venv /opt/venv

WORKDIR /workspace

USER devuser

HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD ["python", "-c", "import pylint, black, pytest, mypy"]

CMD ["/bin/bash"]
