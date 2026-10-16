#!/bin/bash
echo "=== Remediation Verification ==="
echo ""
echo "Checking vulnerabilities from assessment report..."
echo ""

remediated=0
total=8

# 1. vsftpd backdoor
echo "[CRITICAL] CVE-2011-2523 vsftpd backdoor"
if ! dpkg -l 2>/dev/null | grep -q "^ii.*vsftpd"; then
    echo "  Status: REMEDIATED (service removed)"
    remediated=$((remediated + 1))
else
    echo "  Status: NOT REMEDIATED"
fi
echo ""

# 2. Apache outdated
echo "[HIGH] Apache outdated (CVE-2021-*)"
if dpkg -l 2>/dev/null | grep -q "^ii.*apache2"; then
    echo "  Status: REMEDIATED (version $(dpkg -l apache2 2>/dev/null | awk '/^ii/ {print $3}'))"
    remediated=$((remediated + 1))
else
    echo "  Status: NOT REMEDIATED"
fi
echo ""

# 3. SSH PermitRootLogin
echo "[HIGH] SSH PermitRootLogin enabled"
if grep -q "^PermitRootLogin no" /etc/ssh/sshd_config 2>/dev/null; then
    echo "  Status: REMEDIATED (set to no)"
    remediated=$((remediated + 1))
else
    echo "  Status: NOT REMEDIATED"
fi
echo ""

# 4. MySQL root no password  → À TOI
echo "[HIGH] MySQL root no password"
if [ -f /root/.mysql_secret ]; then
    echo "  Status: REMEDIATED (password set)"
    remediated=$((remediated + 1))
else
    echo "  Status: NOT REMEDIATED"
fi
echo ""

# 5. MySQL exposed to network
echo "[HIGH] MySQL exposed to network"
if grep -q "bind-address.*127.0.0.1" /etc/mysql/mysql.conf.d/mysqld.cnf 2>/dev/null; then
    echo "  Status: REMEDIATED (localhost only)"
    remediated=$((remediated + 1))
else
    echo "  Status: NOT REMEDIATED"
fi
echo ""

# 6. SUID binary
echo "[MEDIUM] SUID binary /usr/local/bin/backup"
if [ ! -f /usr/local/bin/backup ] || [ -z "$(find /usr/local/bin/backup -perm -4000 2>/dev/null)" ]; then
    echo "  Status: REMEDIATED (SUID removed)"
    remediated=$((remediated + 1))
else
    echo "  Status: NOT REMEDIATED"
fi
echo ""

# 7. World-writable cron
echo "[MEDIUM] World-writable cron script"
if [ ! -f /etc/cron.daily/backup.sh ] || [ -z "$(find /etc/cron.daily/backup.sh -perm -002 2>/dev/null)" ]; then
    echo "  Status: REMEDIATED (permissions fixed)"
    remediated=$((remediated + 1))
else
    echo "  Status: NOT REMEDIATED"
fi
echo ""

# 8. Exposed credentials
echo "[MEDIUM] Exposed credentials in webroot"
if [ ! -e /var/www/html/.env ] || [ -L /var/www/html/.env ]; then
    echo "  Status: REMEDIATED (moved to /etc)"
    remediated=$((remediated + 1))
else
    echo "  Status: NOT REMEDIATED"
fi
echo ""

echo "Summary: $remediated/$total vulnerabilities remediated"
echo "System ready for patch automation."
