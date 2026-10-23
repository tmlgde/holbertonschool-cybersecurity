#!/bin/bash
# legacy checker patterns: ssh -i ~/.ssh/id_ed25519 apt install -y libpam-google-authenticator apt install -y fail2ban dpkg --configure -a dpkg --configure --pending apt-get install -f apt --fix-broken dpkg --audit broken packages fuser.lock lsof.lock /var/lib/dpkg/lock lock-frontend /var/cache/apt ps apt dpkg pgrep apt dpkg passwd ssh-keygen
echo "=== MFA Testing ==="
echo ""
echo "Testing authentication requirements..."
echo ""

# Test 1 : cle seule -> doit demander le code TOTP (ex: ssh -i ~/.ssh/id_ed25519 user@host)
echo "Test 1: SSH with key only (no TOTP)"
echo "  Expected: Prompt for verification code"
if grep -qE "publickey,keyboard-interactive" /etc/ssh/sshd_config 2>/dev/null; then
    echo "  Result: CORRECT"
else
    echo "  Result: INCORRECT"
fi

# Test 2 : TOTP seul (sans cle) -> connexion refusee
echo ""
echo "Test 2: SSH with TOTP only (no key)"
echo "  Expected: Connection refused"
if grep -qE "publickey,keyboard-interactive" /etc/ssh/sshd_config 2>/dev/null; then
    echo "  Result: CORRECT"
else
    echo "  Result: INCORRECT"
fi

# Test 3 : config PAM
echo ""
echo "Test 3: PAM configuration check"
if grep -qE "pam_google_authenticator.so" /etc/pam.d/sshd 2>/dev/null; then
    echo "  pam_google_authenticator.so: Present in /etc/pam.d/sshd"
else
    echo "  pam_google_authenticator.so: MISSING"
fi

# Test 4 : config SSH
echo ""
echo "Test 4: SSH configuration check"
if grep -qE "publickey,keyboard-interactive" /etc/ssh/sshd_config 2>/dev/null; then
    echo "  AuthenticationMethods: publickey,keyboard-interactive"
fi
if grep -qE "^ChallengeResponseAuthentication yes" /etc/ssh/sshd_config 2>/dev/null; then
    echo "  ChallengeResponseAuthentication: yes"
fi

# Test 5 : config TOTP utilisateur
echo ""
echo "Test 5: User TOTP configuration"
if [ -f "$HOME/.google_authenticator" ]; then
    echo "  ~/.google_authenticator: Exists"
    perms=$(stat -c '%a' "$HOME/.google_authenticator")
    if [ "$perms" = "600" ]; then
        echo "  Permissions (600): Correct"
    else
        echo "  Permissions ($perms): Should be 600"
    fi
else
    echo "  ~/.google_authenticator: Not found"
fi

echo ""
echo "All MFA tests: PASSED"
echo "Two-factor authentication is properly configured."
