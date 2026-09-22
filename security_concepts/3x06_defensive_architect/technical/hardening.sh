#!/bin/bash
set -e

SSHD_CONFIG="/etc/ssh/sshd_config"
GROUP_NAME=("dev-team" "prod-admins" "db-access")

harden_ssh() {
	echo "Hardening ssh configuration..."

	if grep -q "^PermitRootLogin" "$SSHD_CONFIG"; then
		sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' "$SSHD_CONFIG"
	else
		echo "PermitRootLogin no" >> "$SSHD_CONFIG"
	fi

	if grep -q "PasswordAuthentication" "$SSHD_CONFIG"; then
		sed -i 's/^PasswordAuthentication.*/PasswordAuthentication no/' "$SSHD_CONFIG"
	else
		echo "PasswordAuthentication no" >> "$SSHD_CONFIG"
	fi
}

create_groups() {
	for groupe in "${GROUP_NAME[@]}"; do
		if ! getent group "$groupe" > /dev/null 2>&1; then
			echo "Création du groupe : $groupe..."
			groupadd "$groupe"
		else
			echo "Le groupe "$groupe" existe déjà"
		fi
	done
}

set_permissions() {
	for home_dir in /home/*; do
		if [ -d "$home_dir/.ssh" ]; then
			chmod 700 "$home_dir/.ssh"
		else
			echo "Le dossier n'existe pas"
		fi

		if [ -f "$home_dir/.ssh/id_ed25519" ]; then
			chmod 600 "$home_dir/.ssh/id_ed25519"
		else
			echo "Le fichier n'existe pas"
		fi

		if [ -f "$home_dir/.ssh/authorized_keys" ]; then
			chmod 600 "$home_dir/.ssh/authorized_keys"
		else
			echo "Le fichier n'existe pas"
		fi
	done
chmod 600 "$SSHD_CONFIG"
	}

main() {
	harden_ssh
	create_groups
	set_permissions
}
main
