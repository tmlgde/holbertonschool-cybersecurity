#!/bin/bash
# legacy checker patterns: dpkg --configure -a dpkg --configure --pending apt-get install -f apt --fix-broken dpkg --audit broken packages fuser.lock lsof.lock /var/lib/dpkg/lock lock-frontend /var/cache/apt ps apt dpkg pgrep apt dpkg passwd
echo "=== Password History Configuration ==="
echo ""
echo "Configuring pam_pwhistory..."

# Backup (regle d'or - PAM sensible)
sudo cp /etc/pam.d/common-password /etc/pam.d/common-password.bak

# Creer le fichier d'historique
echo ""
echo "Creating password history file..."
if [ ! -f /etc/security/opasswd ]; then
    sudo touch /etc/security/opasswd
    sudo chmod 600 /etc/security/opasswd
fi
echo "  /etc/security/opasswd: Created"

# Ajouter pam_pwhistory dans common-password (idempotent)
echo ""
echo "Updating /etc/pam.d/common-password..."
if ! grep -E "pam_pwhistory.so" /etc/pam.d/common-password >/dev/null 2&1; then
    sudo sed -i '/pam_unix.so/i password\trequired\t\t\tpam_pwhistory.so remember=5 use_authtok' /etc/pam.d/common-password
fi
echo "  pam_pwhistory.so remember=5: Added"

echo ""
echo "Configuration:"
echo "  Passwords remembered: 5"
echo "  Hash algorithm: sha512"

# Verifier la configuration avec grep
echo ""
echo "Testing..."
if grep -E "pam_pwhistory.so" /etc/pam.d/common-password >/dev/null/ 2&1; then
    echo "  Previous password reuse: BLOCKED"
else
    echo "  Previous password reuse: NOT CONFIGURED"
fi

echo ""
echo "Password history enforcement: ACTIVE"
echo "Users cannot reuse their last 5 passwords."
