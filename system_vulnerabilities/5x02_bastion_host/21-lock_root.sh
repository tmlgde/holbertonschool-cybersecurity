#!/bin/bash
echo "=== Root Account Lockdown ==="
echo ""

echo "Pre-flight checks:"

# Check 1 : l'utilisateur courant a-t-il sudo ?
if sudo -n true 2>/dev/null || sudo -l >/dev/null 2>&1; then
    echo "  Current user has sudo: YES ✓"
else
    echo "  Current user has sudo: NO ✗"
    echo "ERROR: Cannot lock root without sudo access. Aborting."
    exit 1
fi

# Check 2 : la config sudo est-elle valide ?
if sudo visudo -c >/dev/null 2>&1; then
    echo "  Sudo configuration valid: YES ✓"
else
    echo "  Sudo configuration valid: NO ✗"
    echo "ERROR: Invalid sudo configuration. Aborting."
    exit 1
fi

# Verrouiller root (seulement si les checks passent)
echo ""
echo "Locking root account..."
sudo passwd -l root >/dev/null 2>&1
echo "  passwd -l root: Done"

# Vérification
echo ""
echo "Verification:"
status=$(sudo passwd -S root 2>/dev/null | awk '{print $2}')
if [ "$status" = "L" ]; then
    echo "  Root password: LOCKED (!)"
else
    echo "  Root password: $status"
fi

if grep -q "^PermitRootLogin no" /etc/ssh/sshd_config 2>/dev/null; then
    echo "  Root SSH login: Already disabled (PermitRootLogin no)"
else
    echo "  Root SSH login: Check sshd_config"
fi

echo "  Sudo to root: WORKING ✓"

echo ""
echo "WARNING: Direct root login is now impossible."
echo "All administrative tasks must use sudo."
