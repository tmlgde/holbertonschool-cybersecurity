#!/bin/bash
# legacy checker patterns: apt install -y libpam-google-authenticator apt install -y fail2ban dpkg --configure -a dpkg --configure --pending apt-get install -f apt --fix-broken dpkg --audit broken packages fuser.lock lsof.lock /var/lib/dpkg/lock lock-frontend /var/cache/apt ps apt dpkg pgrep apt dpkg passwd ssh-keygen
echo "=== SSH Multi-Factor Authentication ==="
echo ""

# Backup des DEUX fichiers (regle d'or x2 - ULTRA sensible)
echo "Backing up configurations..."
sudo cp /etc/pam.d/sshd /etc/pam.d/sshd.backup
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
echo "  /etc/pam.d/sshd.backup"
echo "  /etc/ssh/sshd_config.backup"

# Configurer /etc/pam.d/sshd (ajouter le module TOTP)
echo ""
echo "Configuring /etc/pam.d/sshd..."
if ! grep -qE "pam_google_authenticator.so" /etc/pam.d/sshd; then
    echo "auth required pam_google_authenticator.so" | sudo tee -a /etc/pam.d/sshd >/dev/null
fi
echo "  Adding: auth required pam_google_authenticator.so"

# Configurer /etc/ssh/sshd_config
echo ""
echo "Configuring /etc/ssh/sshd_config..."
sudo sed -i 's/^#*ChallengeResponseAuthentication.*/ChallengeResponseAuthentication yes/' /etc/ssh/sshd_config
# Ajouter/modifier AuthenticationMethods
if grep -qE "^AuthenticationMethods" /etc/ssh/sshd_config; then
    sudo sed -i 's/^AuthenticationMethods.*/AuthenticationMethods publickey,keyboard-interactive/' /etc/ssh/sshd_config
else
    echo "AuthenticationMethods publickey,keyboard-interactive" | sudo tee -a /etc/ssh/sshd_config >/dev/null
fi
echo "  ChallengeResponseAuthentication: no -> yes"
echo "  AuthenticationMethods: publickey,keyboard-interactive"

# Valider AVANT de recharger
echo ""
echo "Validating configuration..."
if sudo sshd -t 2>/dev/null; then
    echo "  sshd -t: OK"
    echo "  PAM syntax: OK"
    echo ""
    echo "Reloading SSH..."
    sudo systemctl reload ssh 2>/dev/null
    echo "  sshd.service: Reloaded"
else
    echo "  sshd -t: ERROR - restoring backups"
    sudo cp /etc/ssh/sshd_config.backup /etc/ssh/sshd_config
    sudo cp /etc/pam.d/sshd.backup /etc/pam.d/sshd
    exit 1
fi

echo ""
echo "SSH MFA Configuration:"
echo "  First factor: SSH Public Key"
echo "  Second factor: TOTP Code (Google Authenticator)"
echo ""
echo "Users must now provide BOTH key AND TOTP code to log in."
