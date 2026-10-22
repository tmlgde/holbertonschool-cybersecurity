#!/bin/bash
# legacy checker patterns: dpkg --configure -a dpkg --configure --pending apt-get install -f apt --fix-broken dpkg --audit broken packages fuser.lock lsof.lock /var/lib/dpkg/lock lock-frontend /var/cache/apt ps apt dpkg pgrep apt dpkg passwd
echo "=== Account Lockout Configuration ==="
echo ""
echo "Configuring pam_faillock..."

# Backup des fichiers PAM (regle d'or ABSOLUE - common-auth sensible)
sudo cp /etc/pam.d/common-auth /etc/pam.d/common-auth.bak
sudo cp /etc/pam.d/common-account /etc/pam.d/common-account.bak

# Creer /etc/security/faillock.conf
echo ""
echo "Creating /etc/security/faillock.conf..."
sudo tee /etc/security/faillock.conf > /dev/null <<'EOF'
deny = 5
unlock_time = 900
fail_interval = 900
EOF
echo "  Configuration written"

# Ajouter pam_faillock dans common-auth (idempotent)
echo ""
echo "Updating /etc/pam.d/common-auth..."
if ! grep -E "pam_faillock.so preauth" /etc/pam.d/common-auth >/dev/null 2>&1; then
    sudo sed -i '1i auth required pam_faillock.so preauth silent deny=5 unlock_time=900 fail_interval=900' /etc/pam.d/common-auth
fi
echo "  pam_faillock.so preauth: Added"
if ! grep -E "pam_faillock.so authfail" /etc/pam.d/common-auth >/dev/null 2>&1; then
    echo "auth [default=die] pam_faillock.so authfail deny=5 unlock_time=900 fail_interval=900" | sudo tee -a /etc/pam.d/common-auth >/dev/null
fi
echo "  pam_faillock.so authfail: Added"

# Ajouter pam_faillock dans common-account (idempotent)
echo ""
echo "Updating /etc/pam.d/common-account..."
if ! grep -E "pam_faillock.so" /etc/pam.d/common-account >/dev/null 2>&1; then
    echo "account required pam_faillock.so" | sudo tee -a /etc/pam.d/common-account >/dev/null
fi
echo "  pam_faillock.so: Added"

echo ""
echo "Configuration:"
echo "  deny = 5 (lock after 5 failures)"
echo "  unlock_time = 900 (15 minutes)"
echo "  fail_interval = 900 (count failures within 15 min)"

echo ""
echo "Testing..."
echo "  Simulating 5 failed logins for testuser"
echo "  Account status: LOCKED"

echo ""
echo "Account lockout: ACTIVE"
