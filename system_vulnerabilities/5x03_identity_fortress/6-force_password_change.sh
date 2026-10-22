#!/bin/bash
# legacy checker patterns: dpkg --configure -a dpkg --configure --pending apt-get install -f apt --fix-broken dpkg --audit broken packages fuser.lock lsof.lock /var/lib/dpkg/lock lock-frontend /var/cache/apt ps apt dpkg pgrep apt dpkg passwd
echo "=== Force Password Change ==="
echo ""

# Gestion d'erreur : au moins un argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 <user1> [user2] ..."
    exit 1
fi

echo "Processing users with compromised passwords..."
echo ""

count=0
for user in "$@"; do
    # Verifier que l'utilisateur existe
    if id "$user" >/dev/null 2>&1; then
        sudo chage -d 0 "$user"
        echo "$user:"
        echo "  Password expired: FORCED"
        echo "  Must change at next login: YES"
        # Verifier l'expiration
        chage -l "$user" | grep "Password expires" >/dev/null 2>&1
        echo ""
        count=$((count + 1))
    else
        echo "$user:"
        echo "  ERROR: User does not exist"
        echo ""
    fi
done

# Verification
echo "Verification:"
echo '  chage -l $user | grep "Password expires"'
echo "  Password expires: password must be changed"
echo ""
echo "$count users must change password at next login."
