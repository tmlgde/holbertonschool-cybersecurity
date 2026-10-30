#!/bin/bash
# init-services.sh - Orchestrateur de demarrage du conteneur (PID 1)
# Demarre les services (SSH + Apache). La config est faite au BUILD.

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [SERVICES] $1"
}

log "=== Container Startup Orchestration ==="

# Preparer les repertoires runtime (tmpfs montes vides au demarrage)
mkdir -p /run/sshd
chmod 0755 /run/sshd
chown root:root /run/sshd
mkdir -p /run/lock
mkdir -p /run/lock/apache2
mkdir -p /run/apache2

# Demarrer le serveur SSH (en arriere-plan)
log "Starting SSH server..."
/usr/sbin/sshd
if pgrep -x sshd >/dev/null 2>&1; then
    log "  SSH server: RUNNING"
else
    log "  SSH server: FAILED to start"
fi

# Verification des services
log "Verifying services..."
if pgrep -x sshd >/dev/null 2>&1; then
    log "  [HEALTH] SSH: OK (listening)"
else
    log "  [HEALTH] SSH: NOT running"
fi

# Demarrer Apache en AVANT-PLAN (foreground) -> devient le PID 1
log "Starting web server (foreground)..."
log "=== Startup complete, container is now serving ==="
source /etc/apache2/envvars 2>/dev/null
exec apache2 -D FOREGROUND

# Filet de securite si exec echoue
exit 0
