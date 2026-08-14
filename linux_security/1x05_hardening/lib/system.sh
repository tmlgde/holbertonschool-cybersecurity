#!/bin/bash

update_system() {
	export DEBIAN_FRONTEND=noninteractive #dit au systeme n'affiche aucun popups, prend toujours la reponse par defaut automatiquement"
	UPGRADED_COUNT=$(apt-get upgrade -y -qq -s | grep -c "^Inst ")
	apt-get update -qq # -qq pour tres silencieux, aucn affichage 
	apt-get upgrade -y -qq
	[ "$UPGRADED_COUNT" -eq 0 ] && WARNINGS+=("Package updates skipped (already up to date)")
	log "System updated: repositories refreshed and packages upgraded"
}

remove_bloatware() {
	apt-get purge -y -qq telnet ftp netcat-traditional inetutils-telnet tnftp
	log "Bloatware removed: telnet, ftp, netcat-traditional purged"
}

install_tools() {
	apt-get install -y -qq auditd fail2ban
	log "System updated: auditd, failban installed"
} 
