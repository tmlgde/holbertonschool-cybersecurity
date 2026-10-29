#!/bin/bash
# init-hardening.sh - Applique les controles de durcissement systeme (Projet 5x02)
# Adapte au contexte conteneur : certains controles kernel sont delegues a l'hote.

# Fonction de log avec horodatage
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [HARDENING] $1"
}

log "=== System Hardening Start ==="

# --- Kernel parameters (sysctl) ---
# Dans un conteneur, le kernel est partage avec l'hote : ces parametres
# ne peuvent generalement pas etre modifies et doivent etre geres au niveau
# de l'hote ou via 'docker run --sysctl'. On tente, on log si delegue.
log "Configuring kernel parameters (sysctl)..."
for param in \
    "net.ipv4.ip_forward=0" \
    "net.ipv4.conf.all.accept_redirects=0" \
    "net.ipv4.conf.all.rp_filter=1" \
    "net.ipv4.tcp_syncookies=1" \
    "net.ipv4.conf.all.accept_source_route=0" \
    "net.ipv4.icmp_echo_ignore_broadcasts=1"; do
    if sysctl -w "$param" >/dev/null 2>&1; then
        log "  Applied: $param"
    else
        log "  [DELEGATED] $param -> must be set on host (kernel is shared)"
    fi
done

log "Minimizing service..."
for svc in cups avahi-daemon bluetooth; do
	if systemctl list-unit-files 2>/dev/null | grep -q "^${svc}"; then
		systemctl disable "$svc" 2>/dev/null && log " Disabled: $svc"
	else
		log " Not present (good): $svc"
	fi
done

# SUID/SGID audit
log "Auditing SUID/SGID binaries..."
suid_count=$(find / -perm -4000 -type f 2>/dev/null | wc -l)
sgid_count=$(find / -perm -2000 -type f 2>/dev/null | wc -l)
log " SUID binaries found: $suid_count"
log " SGID binaries found: $sgid_count"

# --- Filesystem security ---
log "Applying filesystem security..."
# Umask restrictif (fichiers crees sans droits pour les autres)
umask 027
# Proteger les fichiers sensibles (permissions strictes)
chmod 600 /etc/shadow 2>/dev/null && log "  Secured: /etc/shadow (600)"
chmod 644 /etc/passwd 2>/dev/null && log "  Secured: /etc/passwd (644)"
chmod 700 /etc/ssh 2>/dev/null && log "  Secured: /etc/ssh (700)"
# Note: noexec/nosuid/nodev sur /tmp se configurent au runtime (--tmpfs)
log "  Note: /tmp noexec/nosuid -> applied at runtime via --tmpfs"

# Legal Banner
log "Configuring legal banner..."
cat > /etc/issue.net <<'EOF'
AUTHORIZED ACCESS ONLY
This system is the proprety of NovaTech Solutions.
Unauthorized access is prohibited and will be prosecuted
All activities are monitored and logged.
EOF
log " Legal banner written to /etc/issue.net"
log " System hardening complete"
exit 0
