#!/bin/bash
# Identity functions

configure_password_policy() {
	local FILE="/etc/login.defs"
	grep -q "^PASS_MAX_DAYS" "$FILE" && sed  -i "s/^PASS_MAX_DAYS.*/PASS_MAX_DAYS $PASS_MAX_DAYS/" "$FILE" || echo "PASS_MAX_DAYS $PASS_MAX_DAYS" >> "$FILE" # meme principe que les autres fonctions. Si il y'a PASS_MAX_DAYS dans le fichier, on remplace la ligne sinon on ajoute
	log "Password policy configured: PASS_MAX_DAYS"="$PASS_MAX_DAYS"

	local PAM_FILE="/etc/pam.d/common-password"
	grep -q "pam_pwquality.so" "$PAM_FILE" && sed -i "s/.*pam_pwquality.so.*/password requisite pam_pwquality.so retry=3 minlen=$PASS_MIN_LEN ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1/" "$PAM_FILE" || sed -i "1i password requisite pam_pwquality.so retry=3 minlen="$PASS_MIN_LEN" ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1" "$PAM_FILE"
	log "Password policy configured: PASS_MAX_DAYS=$PASS_MAX_DAYS, PASS_MIN_LEN=$PASS_MIN_LEN, complexity enforced"
}

configure_lockout() {
	local FILE="/etc/pam.d/common-auth"
	grep -q "pam_faillock.so" "$FILE" || sed -i "1i auth required pam_faillock.so preauth silent deny=$FAIL_LOCK_ATTEMPTS unlock_time=900" "$FILE" # meme principe, 1i pour dire a sed d'inserer avant la ligne 1 car on veut executer avant le module qui verifie le mot de passe
	log "Account lockout configured: deny=$FAIL_LOCK_ATTEMPTS unlock_time=900"
}

cleanup_users() {
	while IFS=: read -r username _ uid _ _ _ _; do
		if [ "$uid" -gt 1000 ] && [ "$uid" -lt 65534 ]; then
			if ! groups "$username" | grep -qE "\b(sudo|wheel)\b"; then
				userdel -r "$username"
				REMOVED_USERS+=("$username)"
				log "Removed unauthorized user : $username (UID $uid, not in sudo/wheel)"
			fi
		fi
	done < /etc/passwd
}

lock_root() {
	if ! passwd -S root | awk '{print $2}' | grep -q "^L"; then
		passwd -l root
		log "Root account locked: password-based login disabled"
	fi
}
