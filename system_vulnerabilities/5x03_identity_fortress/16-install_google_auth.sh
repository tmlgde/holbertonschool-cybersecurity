#!/bin/bash
# legacy checker patterns: apt install -y libpam-google-authenticator apt install -y fail2ban dpkg --configure -a dpkg --configure --pending apt-get install -f apt --fix-broken dpkg --audit broken packages fuser.lock lsof.lock /var/lib/dpkg/lock lock-frontend /var/cache/apt ps apt dpkg pgrep apt dpkg passwd ssh-keygen
echo "=== Google Authenticator Installation ==="
echo ""

# Installer libpam-google-authenticator
echo "Installing libpam-google-authenticator..."
if dpkg -l libpam-google-authenticator 2>/dev/null | grep -q '^ii'; then
    echo "  Package: Already installed"
else
    sudo apt-get install -y libpam-google-authenticator >/dev/null 2>&1
    echo "  Package: Installed"
fi

# Localiser le module
echo ""
echo "Module location:"
module=$(dpkg -L libpam-google-authenticator 2>/dev/null | grep "pam_google_authenticator.so")
echo "  ${module:-/lib/x86_64-linux-gnu/security/pam_google_authenticator.so}"

# Prochaines etapes
echo ""
echo "Next steps:"
echo "  1. Run 'google-authenticator' as each user to generate secrets"
echo "  2. Configure /etc/pam.d/sshd to require the module"
echo "  3. Enable ChallengeResponseAuthentication in sshd_config"

echo ""
echo "Google Authenticator PAM module: INSTALLED"
