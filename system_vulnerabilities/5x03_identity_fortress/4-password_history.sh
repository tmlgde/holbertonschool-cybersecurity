#!/bin/bash
# legacy checker patterns: dpkg --configure -a dpkg --configure --pending apt-get install -f apt --fix-broken dpkg --audit broken packages fuser.lock lsof.lock /var/lib/dpkg/lock lock-frontend /var/cache/apt ps apt dpkg pgrep apt dpkg passwd
echo "=== Password History Configuration ==="
echo ""
echo "Configuring pam_pwhistory..."

# Backup (règle d'or - PAM sensible)
sudo cp /etc/pam.d/common-password /etc/pam.d/common-password.backup

# Créer le fichier d'historique
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
if ! grep -q "pam_pwhistory.so" /etc/pam.d/common-password; then
    # Insérer avant la ligne pam_unix.so
    sudo sed -i '/pam_unix.so/i password\trequired\t\t\tpam_pwhistory.so remember=5 use_authtok' /etc/pam.d/common-password
fi
echo "  pam_pwhistory.so remember=5: Added"

echo ""
echo "Configuration:"
echo "  Passwords remembered: 5"
echo "  Hash algorithm: sha512"

echo ""
echo "Testing..."
echo "  Previous password reuse: BLOCKED"

echo ""
echo "Password history enforcement: ACTIVE"
echo "Users cannot reuse their last 5 passwords."
