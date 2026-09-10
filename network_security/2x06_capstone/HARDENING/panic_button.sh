#!/bin/bash

mkdir -p /root/hardening-backup #créer le dossier qui contient les sauvegardes

#Copie des fichiers et affiche l'état actuel du firewall et redirige le resultat
cp /etc/ssh/sshd_config /root/hardening-backup/sshd_config.pre
nft list ruleset > /root/hardening-backup/nftables.pre.conf

#créer un fichier vide qui sert de verrou. Tant qu'il existe, ca veut dire "la securité est encore armée, rien n'a été confirmé
touch /root/hardening-backup/armed.lock

#Tout dans ce bloc montre quoi faire pour redémarrer le firewall"
(
	sleep 900
	if [ -f /root/hardening-backup/armed.lock ]; then
		nft -f /root/hardening-backup/nftables.pre.conf
		cp /root/hardening-backup/sshd_config.pre /etc/ssh/sshd_config
		service ssh restart
	fi
) &

echo "Pannic button armed. 900 seconds"
echo "rm /root/hardening-backup/armed.lock"
