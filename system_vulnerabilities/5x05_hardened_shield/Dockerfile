# Image de base minimale avec Python (pour audit.py)
FROM python:3.11-slim

# Metadata OCI (standard)
LABEL org.opencontainers.image.title="Hardened Shield" \
      org.opencontainers.image.description="Production-ready hardened container base" \
      org.opencontainers.image.vendor="NovaTech Solutions" \
      org.opencontainers.image.version="1.0.0"

# Installation des paquets dans un SEUL RUN (une seule couche, nettoyage inclus)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        apache2 \
        openssh-server \
        libpam-pwquality \
        libpam-google-authenticator \
        curl \
        procps && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Creer un utilisateur non-root dedie
RUN groupadd --gid 1000 appuser && \
    useradd --uid 1000 --gid appuser --no-create-home --shell /usr/sbin/nologin appuser

# Copier les scripts d'initialisation (liste blanche, pas COPY .)
COPY scripts/init-hardening.sh /usr/local/bin/init-hardening.sh
COPY scripts/init-identity.sh /usr/local/bin/init-identity.sh
COPY scripts/init-services.sh /usr/local/bin/init-services.sh
COPY scripts/audit.py /usr/local/bin/audit.py

# Rendre les scripts executables
RUN chmod +x /usr/local/bin/init-hardening.sh \
             /usr/local/bin/init-identity.sh \
             /usr/local/bin/init-services.sh \
             /usr/local/bin/audit.py

# Appliquer le durcissement au build
RUN /usr/local/bin/init-hardening.sh && \
    /usr/local/bin/init-identity.sh

# Generer les cles d'hote SSH au build
RUN ssh-keygen -A

# Dossier web + page de sante pour le HEALTHCHECK
RUN mkdir -p /var/www/html && \
    echo "OK" > /var/www/html/health

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD curl -f http://localhost/health || exit 1

# Documenter les ports utilises
EXPOSE 80 22

# Quoi lancer au demarrage (uniquement les services maintenant)
CMD ["/usr/local/bin/init-services.sh"]
