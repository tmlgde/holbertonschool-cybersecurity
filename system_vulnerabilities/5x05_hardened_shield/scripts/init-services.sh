#!/bin/bash
# init-services.sh - Orchestrateur de demarrage du conteneur (PID 1)
# Lance les scripts de durcissement, demarre les services, et maintient le conteneur en vie.

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [SERVICES] $1"
}

log "=== Container Startup Orchestration ==="

# 1. Appliquer le durcissement systeme (5x02)
log "Running system hardening..."
/usr/local/bin/init-hardening.sh

# 2. Appliquer les controles d'identite (5x03)
log "Running identity hardening..."
/usr/local/bin/init-identity.sh

# 3. Demarrer le serveur SSH (en arriere-plan)
log "Starting SSH server..."
# Generer les cles d'hote SSH si absentes
ssh-keygen -A >/dev/null 2>&1
# Creer le repertoire runtime de sshd
mkdir -p /run/sshd
/usr/sbin/sshd
if pgrep -x sshd >/dev/null 2>&1; then
    log "  SSH server: RUNNING"
else
    log "  SSH server: FAILED to start"
fi

# 4. Verification des services avant de passer au foreground
log "Verifying services..."

# Verifier SSH (deja fait, mais on consolide le health check)
if pgrep -x sshd >/dev/null 2>&1; then
    log "  [HEALTH] SSH: OK (listening)"
else
    log "  [HEALTH] SSH: NOT running"
fi

# 5. Demarrer Apache en AVANT-PLAN (foreground) -> devient le PID 1
log "Starting web server (foreground)..."
log "=== Startup complete, container is now serving ==="

# apache2ctl -D FOREGROUND garde Apache au premier plan :
# tant qu'Apache tourne, le conteneur vit. S'il crash, le conteneur s'arrete.
exec apache2ctl -D FOREGROUND

# SI exec echoue, on sort proprement
exit 0
