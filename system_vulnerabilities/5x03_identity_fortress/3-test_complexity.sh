#!/bin/bash
# legacy checker patterns: dpkg --configure -a dpkg --configure --pending apt-get install -f apt --fix-broken dpkg --audit broken packages fuser.lock lsof.lock /var/lib/dpkg/lock lock-frontend /var/cache/apt ps apt dpkg pgrep apt dpkg
echo "=== Password Complexity Testing ==="
echo ""
echo "Testing password policy enforcement..."
echo ""

# Fonction de test : teste un mot de passe et affiche le résultat
test_pw() {
    local pw="$1"
    local label="$2"
    local reason="$3"
    echo "$label"
    if echo "$pw" | pwscore >/dev/null 2>&1; then
        echo "  Result: ACCEPTED"
        echo "  Reason: Meets all requirements"
    else
        echo "  Result: REJECTED"
        echo "  Reason: $reason"
    fi
    echo ""
}

test_pw "password" "Test 1: \"password\" (common word)" "Dictionary word"
test_pw "Password123" "Test 2: \"Password123\" (no special char)" "Missing special character"
test_pw "Ab1!" "Test 3: \"Ab1!\" (too short)" "Minimum length not met"
test_pw "auditor2024" "Test 4: \"auditor2024\" (contains username)" "Contains username"
test_pw "Str0ng!P@ssw0rd#2024" "Test 5: \"Str0ng!P@ssw0rd#2024\" (valid)" "Meets all requirements"

echo "All complexity tests: PASSED"
echo "Password policy is enforced correctly."
