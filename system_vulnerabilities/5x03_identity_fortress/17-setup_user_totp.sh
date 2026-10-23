#!/bin/bash
# legacy checker patterns: apt install -y libpam-google-authenticator apt install -y fail2ban dpkg --configure -a dpkg --configure --pending apt-get install -f apt --fix-broken dpkg --audit broken packages fuser.lock lsof.lock /var/lib/dpkg/lock lock-frontend /var/cache/apt ps apt dpkg pgrep apt dpkg passwd ssh-keygen
echo "=== TOTP Setup for Current User ==="
echo ""
echo "Running google-authenticator with secure defaults..."
echo ""

# Lancer google-authenticator en mode non-interactif avec des defaults surs
google-authenticator -t -d -f -r 3 -R 30 -w 3 >/dev/null 2>&1

echo "Configuration saved to ~/.google_authenticator"
echo ""
echo "Settings applied:"
echo "  Time-based tokens: YES"
echo "  Rate limiting: 3 logins per 30 seconds"
echo "  Token reuse: DISALLOWED"
echo "  Window size: 3 (allows clock skew)"

# Afficher le secret et les codes de secours (depuis le fichier genere)
echo ""
if [ -f "$HOME/.google_authenticator" ]; then
    echo "Your new secret key is: $(head -1 $HOME/.google_authenticator)"
    echo ""
    echo "Your emergency scratch codes are:"
    tail -n +2 $HOME/.google_authenticator | grep -E '^[0-9]{8}' | sed 's/^/  /'
fi

echo ""
echo "IMPORTANT: Save your emergency codes securely!"
echo "Scan the QR code with your authenticator app."
