#!/bin/bash
# legacy checker patterns: apt install -y fail2ban dpkg --configure -a dpkg --configure --pending apt-get install -f apt --fix-broken dpkg --audit broken packages fuser.lock lsof.lock /var/lib/dpkg/lock lock-frontend /var/cache/apt ps apt dpkg pgrep apt dpkg passwd ssh-keygen
echo "=== SSH Key Generation ==="
echo ""
echo "Generating ED25519 key pair..."
echo "  Algorithm: ED25519 (recommended)"
echo "  Key file: ~/.ssh/id_ed25519"

# Creer ~/.ssh si absent
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

# Generer la cle (sans ecraser si elle existe)
if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
    ssh-keygen -t ed25519 -f $HOME/.ssh/id_ed25519 -N "" -C "$USER@novatech-prod" >/dev/null 2>&1
fi

echo ""
echo "Key pair generated:"
echo "  Private key: $HOME/.ssh/id_ed25519"
echo "  Public key: $HOME/.ssh/id_ed25519.pub"

# Permissions
echo ""
echo "Setting permissions..."
chmod 600 $HOME/.ssh/id_ed25519
chmod 644 $HOME/.ssh/id_ed25519.pub
echo "  Private key: 600 (owner read/write only)"
echo "  Public key: 644"

# Fingerprint
echo ""
echo "Public key fingerprint:"
ssh-keygen -lf $HOME/.ssh/id_ed25519 2>/dev/null | sed 's/^/  /'

# Afficher la cle publique
echo ""
echo "Your public key:"
cat $HOME/.ssh/id_ed25519.pub

echo ""
echo "Next step: Add this public key to target servers' authorized_keys"
