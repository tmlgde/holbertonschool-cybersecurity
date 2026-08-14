#!/bin/bash

update_system() {
	export DEBIAN_FRONTEND=noninteractive #dit au systeme n'affiche aucun popups, prend toujours la reponse par defaut automatiquement"
	apt-get update -qq # -qq pour tres silencieux, aucn affichage 
	apt-get upgrade -y -qq
	log "System updated: repositories refreshed and packages upgraded"
}

remove_bloatware() {
	apt-get purge -y -qq telnet ftp netcat-traditional
	log "Bloatware removed: telnet, ftp, netcat-traditional purged"
}

install_tools() {
	apt-get install -y -qq auditd fail2ban
	log "System updated: auditd, failban installed"
} 
