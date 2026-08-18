#!/bin/bash
configure_firewall_policy() {
	mkdir -p /etc/hardening #créer le fichier et ses parents si jamais
	{
		echo "DEFAULT_INPUT=deny" #on choisit quel port peut se co
		echo "DEFAULT_OUTPUT=allow" # le serveur peut se co partout
		echo "ALLOW_TCP=$SSH_PORT" #on ouvre un port précis, ici 22
		[ "$ALLOW_HTTP" == "yes" ] && echo "ALLOW_TCP=80"
		[ "$ALLOW_HTTPS" == "yes" ] && echo "ALLOW_TCP=443"
} > /etc/hardening/firewall.rules #connexion http ou https, ok et on ecrase
log "Firewall policy written to /etc/hardening/firewall.rules"
}

harden_kernel() {
	local FILE="/etc/sysctl.conf"
	grep -q "^net.ipv4.ip_forward" "$FILE" && sed -i "s/net.ipv4.ip_forward.*/net.ipv4.ip_forward=0/" "$FILE" || echo "net.ipv4.ip_forward=0" >> "$FILE" #Si le reglage existe dans le fichier, corrige sa valeur sinon ajoute le.
	grep -q "^net.ipv4.icmp_echo_ignore_all" "$FILE" && sed -i "s/^net.ipv4.icmp_echo_ignore_all.*/net.ipv4.icmp_echo_ignore_all=1/" "$FILE" || echo "net.ipv4.icmp_echo_ignore_all=1" >> "$FILE" #Valeur voulue ici est 1. 1 =activé=ignoré. Donc ici on ignore tous les pings reçu.
	log "Kernel hardened: IP forwarding disabled, ICMP echo ignored"
}
