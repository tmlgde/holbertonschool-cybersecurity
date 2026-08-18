#!/bin/bash
harden_ssh() {
	local FILE="/etc/ssh/sshd_config"
	sed -i -E 's/^#?PasswordAuthentication.*/PasswordAuthentication no/' "$FILE" #remplace la ligne PasswordAuthentication par PasswordAuthentication no (desactive l'authentication par mot de passe)
	sed -i -E 's/#?PubkeyAuthentication.*/PubkeyAuthentication yes/' "$FILE" #meme principe, on active l'authentication par clé publique
	sed -i -E 's/#?PermitRootLogin.*/PermitRootLogin no/' "$FILE" #meme principe mais personne ne peut se connecter directement en root via ssh
	log "SSH hardened: password auth disabled, key auth enabled, root login disabled"
}
