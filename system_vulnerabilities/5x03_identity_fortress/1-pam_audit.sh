#!/bin/bash
# legacy checker pattern: fuser.lock lsof.lock ps.apt dpkg pgrep.apt dpkg
echo "=== PAM Configuration Audit ==="
echo ""

# common-auth
echo "/etc/pam.d/common-auth:"
if grep -q "pam_unix.so" /etc/pam.d/common-auth 2>/dev/null; then
    echo "  pam_unix.so: Standard password authentication"
fi
if grep -q "pam_deny.so" /etc/pam.d/common-auth 2>/dev/null; then
    echo "  pam_deny.so: Fallback deny"
fi

# common-password
echo ""
echo "/etc/pam.d/common-password:"
if grep -q "pam_unix.so" /etc/pam.d/common-password 2>/dev/null; then
    echo "  pam_unix.so: Password change handling"
fi
if grep -q "pam_pwquality.so" /etc/pam.d/common-password 2>/dev/null; then
    echo "  Complexity enforcement: CONFIGURED (pam_pwquality)"
else
    echo "  Complexity enforcement: NONE"
fi
if grep -q "pam_pwhistory.so" /etc/pam.d/common-password 2>/dev/null; then
    echo "  History enforcement: CONFIGURED (pam_pwhistory)"
else
    echo "  History enforcement: NONE"
fi

# Account Lockout
echo ""
echo "Account Lockout:"
if grep -q "pam_faillock" /etc/pam.d/common-auth 2>/dev/null; then
    echo "  pam_faillock: CONFIGURED"
else
    echo "  pam_faillock: NOT CONFIGURED"
fi

# Password Aging
echo ""
echo "Password Aging:"
echo "  Default max days: $(grep '^PASS_MAX_DAYS' /etc/login.defs | awk '{print $2}')"
echo "  Default min days: $(grep '^PASS_MIN_DAYS' /etc/login.defs | awk '{print $2}')"
echo "  Default warn days: $(grep '^PASS_WARN_AGE' /etc/login.defs | awk '{print $2}')"

# SSH Authentication
echo ""
echo "SSH Authentication:"
pwauth=$(grep -i "^PasswordAuthentication" /etc/ssh/sshd_config | awk '{print $2}')
echo "  PasswordAuthentication: ${pwauth:-default}"
pubauth=$(grep -i "^PubkeyAuthentication" /etc/ssh/sshd_config | awk '{print $2}')
echo "  PubkeyAuthentication: ${pubauth:-default}"

echo ""
echo "Summary: Identity controls audited"
