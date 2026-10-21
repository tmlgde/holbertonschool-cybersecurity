#!/bin/bash
# ============================================================
# Master Hardening Script - NovaTech Bastion Host
# Transforms a fresh Ubuntu 20.04 server into a hardened bastion
# Idempotent - safe to run multiple times
# ============================================================

LOGFILE="/var/log/hardening/master_harden.log"
sudo mkdir -p /var/log/hardening

# --- Fonction de logging ---
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | sudo tee -a "$LOGFILE" >/dev/null
    echo "$1"
}

# --- Module 1 : Durcissement kernel ---
harden_kernel() {
    log "=== Hardening kernel parameters ==="
    local conf="/etc/sysctl.d/99-hardening.conf"
    sudo touch "$conf"
    local params="net.ipv4.ip_forward=0 net.ipv6.conf.all.forwarding=0 net.ipv4.conf.all.accept_redirects=0 net.ipv4.conf.all.send_redirects=0 net.ipv4.conf.all.rp_filter=1 net.ipv4.tcp_syncookies=1 net.ipv4.conf.all.accept_source_route=0 net.ipv4.icmp_echo_ignore_broadcasts=1"
    for pv in $params; do
        local p="${pv%%=*}"
        local v="${pv##*=}"
        sudo sysctl -w "$p=$v" >/dev/null 2>&1
        sudo sed -i "\|$p|d" "$conf"
        echo "$p = $v" | sudo tee -a "$conf" >/dev/null
    done
    log "Kernel hardening applied"
}

# --- Module 2 : Minimisation des services ---
minimize_services() {
    log "=== Disabling unnecessary services ==="
    for svc in cups.service avahi-daemon.service bluetooth.service; do
        if systemctl list-unit-files 2>/dev/null | grep -q "^${svc}"; then
            sudo systemctl stop "$svc" 2>/dev/null
            sudo systemctl disable "$svc" 2>/dev/null
            log "Disabled $svc"
        fi
    done
}

# --- Module 3 : Suppression des compilateurs ---
remove_compilers() {
    log "=== Removing development tools ==="
    for pkg in gcc g++ make gdb; do
        if dpkg -l "$pkg" 2>/dev/null | grep -q '^ii'; then
            sudo apt-get remove -y "$pkg" >/dev/null 2>&1
            log "Removed $pkg"
        fi
    done
    sudo apt-get autoremove -y >/dev/null 2>&1
}

# --- Module 4 : Durcissement filesystem ---
harden_filesystem() {
    log "=== Hardening temporary filesystems ==="
    sudo cp /etc/fstab /etc/fstab.backup.$(date +%Y%m%d) 2>/dev/null
    sudo sed -i '\| /tmp |d' /etc/fstab
    echo "tmpfs /tmp tmpfs defaults,noexec,nosuid,nodev 0 0" | sudo tee -a /etc/fstab >/dev/null
    sudo mount -o remount,noexec,nosuid,nodev /tmp 2>/dev/null
    log "/tmp hardened with noexec,nosuid,nodev"
}

# --- Module 5 : Verrouillage root ---
lock_root() {
    log "=== Locking root account ==="
    if sudo -l >/dev/null 2>&1; then
        sudo passwd -l root >/dev/null 2>&1
        log "Root account locked"
    fi
}

# --- Module 6 : Banniere legale ---
configure_banner() {
    log "=== Configuring legal banner ==="
    sudo tee /etc/issue.net > /dev/null <<'EOF'
AUTHORIZED ACCESS ONLY
This system is the property of NovaTech Solutions.
Unauthorized access is prohibited and will be prosecuted.
EOF
    sudo sed -i 's|^#*Banner.*|Banner /etc/issue.net|' /etc/ssh/sshd_config
    log "Legal banner configured"
}

# ============================================================
# Execution principale
# ============================================================
echo "=== NovaTech Master Hardening Script ==="
log "Hardening started"

harden_kernel
minimize_services
remove_compilers
harden_filesystem
lock_root
configure_banner

log "Hardening completed"
echo ""
echo "Master hardening complete. Log: $LOGFILE"
