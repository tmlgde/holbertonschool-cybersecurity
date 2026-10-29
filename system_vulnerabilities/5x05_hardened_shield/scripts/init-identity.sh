#!/bin/bash
# init-identity.sh - Applique les controles d'identite et d'acces (Projet 5x03)
# Mots de passe, verrouillage de compte, durcissement SSH, verrouillage root.

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [IDENTITY] $1"
}

log "=== Identity Hardening Start ==="

# --- Password policies (pam_pwquality) ---
log "Configuring password complexity policy..."
PWQUALITY="/etc/security/pwquality.conf"

# Fonction pour poser un parametre (idempotent : retire l'ancien puis ajoute)
set_pwquality() {
    local key="$1"
    local val="$2"
    sed -i "\|^#*\s*${key}\s*=|d" "$PWQUALITY" 2>/dev/null
    echo "${key} = ${val}" >> "$PWQUALITY"
}

# Creer le fichier s'il n'existe pas
touch "$PWQUALITY"

set_pwquality minlen 12
set_pwquality dcredit -1
set_pwquality ucredit -1
set_pwquality lcredit -1
set_pwquality ocredit -1
set_pwquality difok 3
log "  Password policy: minlen=12, complexity enforced (upper/lower/digit/special)"

# Account lockout (pam_faillock)
log "Configuring account lockout policy..."
FAILLOCK="/etc/security/faillock.conf"

# Creer/configurer faillock.conf (idempotent)
touch "$FAILLOCK"
set_faillock() {
    local key="$1"
    local val="$2"
    sed -i "\|^#*\s*${key}\s*=|d" "$FAILLOCK" 2>/dev/null
    echo "${key} = ${val}" >> "$FAILLOCK"
}

set_faillock deny 5
set_faillock unlock_time 900
set_faillock fail_interval 900
log "  Account lockout: deny=5, unlock_time=900s, fail_interval=900s"

#(sshd_config)
log "Hardening SSH configuration..."
SSHD_CONFIG="/etc/ssh/sshd_config"

# Backup (regle d'or : toujours sauvegarder avant de modifier)
cp "$SSHD_CONFIG" "${SSHD_CONFIG}.bak" 2>/dev/null

# Fonction pour poser une directive sshd (idempotent)
set_sshd() {
    local key="$1"
    local val="$2"
    sed -i "\|^#*\s*${key}\b|d" "$SSHD_CONFIG" 2>/dev/null
    echo "${key} ${val}" >> "$SSHD_CONFIG"
}

set_sshd PasswordAuthentication no
set_sshd PermitRootLogin no
set_sshd PubkeyAuthentication yes
set_sshd X11Forwarding no
set_sshd MaxAuthTries 3
set_sshd ChallengeResponseAuthentication no

log "  SSH: password auth DISABLED, root login DISABLED, pubkey ENABLED"

# Root account lockdown
log "Locking root account..."
if passwd -l root >/dev/null 2>&1; then
    log "  Root password: LOCKED"
else
    log "  Root password: already locked or unavailable"
fi
log "=== Identity Hardening Complete ==="
exit 0
