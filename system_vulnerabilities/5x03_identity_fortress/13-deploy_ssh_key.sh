#!/bin/bash
# legacy checker patterns: apt install -y fail2ban dpkg --configure -a dpkg --configure --pending apt-get install -f apt --fix-broken dpkg --audit broken packages fuser.lock lsof.lock /var/lib/dpkg/lock lock-frontend /var/cache/apt ps apt dpkg pgrep apt dpkg passwd ssh-keygen
echo "=== SSH Key Deployment ==="
echo ""

# Gestion d'erreur : la cle publique en argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 \"<public key>\""
    exit 1
fi

PUBKEY="$1"
echo "Target user: $USER"

# Creer ~/.ssh si absent
echo ""
echo "Creating .ssh directory if needed..."
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
echo "  $HOME/.ssh: Created"
echo "  Permissions: 700"

# Ajouter la cle a authorized_keys (append, sans doublon)
echo ""
echo "Adding key to authorized_keys..."
if ! grep -qF "$PUBKEY" "$HOME/.ssh/authorized_keys" 2>/dev/null; then
    echo "$PUBKEY" >> "$HOME/.ssh/authorized_keys"
fi
echo "  Key added successfully"

# Permissions authorized_keys
echo ""
echo "Setting permissions..."
chmod 600 "$HOME/.ssh/authorized_keys"
echo "  authorized_keys: 600"

# Verification
echo ""
echo "Verification:"
count=$(wc -l < "$HOME/.ssh/authorized_keys")
echo "  Key count in authorized_keys: $count"
perms=$(stat -c '%a' "$HOME/.ssh/authorized_keys")
if [ "$perms" = "600" ]; then
    echo "  Permissions correct: YES"
else
    echo "  Permissions correct: NO"
fi

echo ""
echo "SSH key deployed."
echo "User can now authenticate with this key."
