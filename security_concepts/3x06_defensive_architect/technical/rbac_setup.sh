#!/bin/bash

set -e

GROUP_NAME=("devs" "ops" "auditors")
USER_NAME=("dave" "sarah" "audit_user")

create_groups_and_users() {
	for groupe in "${GROUP_NAME[@]}"; do
		if ! getent group "$groupe" > /dev/null 2>&1; then
			echo "Creation de groupe : $groupe..."
			groupadd "$groupe"
		else
			echo "Le groupe "$groupe" existe déjà"
		fi
	done

	for user in "${USER_NAME[@]}"; do
		if ! getent passwd "$user" > /dev/null 2>&1; then
			echo "Création d'utilisateur : $user..."
			useradd -m "$user"
		else
			echo "L'utilisateur "$user" existe déjà"
		fi
	done

usermod -aG devs dave
usermod -aG ops sarah
usermod -aG auditors audit_user

}

configure_sudoers() {
	local SUDOERS_FILE="/etc/sudoers.d/ops-nginx"

	echo "Configuration sudoers pour le groupe ops..."

	echo "%ops ALL=(root) NOPASSWD: /usr/bin/systemctl restart nginx, /usr/bin/systemctl status nginx" > "$SUDOERS_FILE"
	
	chmod 0440 "$SUDOERS_FILE"
}

grant_log_access() {
	if [ -d /var/log/nginx ]; then
		chgrp devs /var/log/nginx
		chmod 750 /var/log/nginx

		find /var/log/nginx -type f -exec chgrp devs {} \;
		find /var/log/nginx -type f -exec chmod 640 {} \;
	else
		"Le dossier n'existe pas"
	fi
}

set_home_permissions() {
	for user in "${USER_NAME[@]}"; do
		if [ -d "/home/$user" ]; then
			chown $user /home/$user
			chmod 700 /home/$user
		fi
	done
}

main() {
	create_groups_and_users
	configure_sudoers
	grant_log_access
	set_home_permissions
}
main
