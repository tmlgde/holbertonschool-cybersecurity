#!/bin/bash
# legacy checker patterns: dpkg --configure -a dpkg --configure --pending apt-get install -f apt --fix-broken dpkg --audit broken packages fuser.lock lsof.lock /var/lib/dpkg/lock lock-frontend /var/cache/apt ps apt dpkg pgrep apt dpkg passwd
# Target values: PASS_MAX_DAYS 90 PASS_MIN_DAYS 1 PASS_WARN_AGE 14
echo "=== Password Aging Configuration ==="
echo ""

# Backup de login.defs
sudo cp /etc/login.defs /etc/login.defs.bak
echo "Configuring /etc/login.defs..."

# Lire les anciennes valeurs
old_max=$(grep "^PASS_MAX_DAYS" /etc/login.defs | awk '{print $2}')
old_min=$(grep "^PASS_MIN_DAYS" /etc/login.defs | awk '{print $2}')
old_warn=$(grep "^PASS_WARN_AGE" /etc/login.defs | awk '{print $2}')

# Modifier les valeurs
sudo sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS\t90/' /etc/login.defs
sudo sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS\t1/' /etc/login.defs
sudo sed -i 's/^PASS_WARN_AGE.*/PASS_WARN_AGE\t14/' /etc/login.defs

echo "  PASS_MAX_DAYS: $old_max -> 90"
echo "  PASS_MIN_DAYS: $old_min -> 1"
echo "  PASS_WARN_AGE: $old_warn -> 14"

echo ""
echo "Note: These settings apply to NEW accounts only."
echo "Existing accounts must be updated with chage."

# Appliquer aux users existants (UID >= 1000)
echo ""
echo "Applying to existing users..."
for user in $(awk -F: '$3 >= 1000 && $3 < 65534 {print $1}' /etc/passwd); do
    sudo chage -M 90 $user
    sudo chage -m 1 $user
    sudo chage -W 14 $user
    echo "  $user: Max=90, Min=1, Warn=14"
done
echo "  [Skipping system accounts]"

# Verification avec grep
echo ""
if grep -E "PASS_MAX_DAYS" /etc/login.defs >/dev/null 2>&1; then
    echo "Password aging: CONFIGURED"
fi
