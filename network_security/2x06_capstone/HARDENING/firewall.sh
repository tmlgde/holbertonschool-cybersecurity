#!/bin/bash
if [ $EUID -ne 0 ]; then
	echo "This script must be run as root."
	exit 1
fi

#Activer l'ip forwarding
sysctl -w net.ipv4.ip_forward=1


#Activer le language nft, puis création des blocs firewall
cat > /etc/nftables.conf <<'NFT'
table inet filter {
	chain input {
		type filter hook input priority 0;
		policy drop;
		ct state established,related accept;
		iifname "lo" accept;
		iifname "eth1" udp dport 51820 accept;
		log prefix "INPUT-DROP: " drop;
	}
	chain forward {
		type filter hook forward priority 0;
		policy drop;
		ct state established,related accept;
		ip saddr 10.30.30.50 ip daddr 10.40.40.2 tcp dport 3306 accept;
		ip saddr 10.10.10.2 ip daddr 10.30.30.50 tcp dport 22 accept;
		ip saddr 10.10.10.3 ip daddr 10.20.20.10 tcp dport 21 accept;
		ip saddr 10.10.10.3 ip daddr 10.20.20.10 tcp dport 21000-21010 accept;
		ip saddr { 10.30.30.0/24, 10.50.50.0/24, 10.10.10.0/24 } tcp dport { 80, 443 } accept;
		ip saddr { 10.30.30.0/24, 10.50.50.0/24, 10.10.10.0/24 } udp dport 53 accept;
		ip saddr 10.50.50.0/24 ip daddr 10.30.30.0/24 log prefix "GUEST-TO-LAN-DENIED: " drop;
		ip saddr 10.50.50.0/24 ip daddr 10.40.40.0/28 log prefix "GUEST-TO-DB-DENIED: " drop;
		ip saddr 10.20.20.0/24 ip daddr 10.40.40.0/28 log prefix "DMZ-TO-DB-DENIED: " drop;
		log prefix "FORWARD-DROP: " drop;
	}
	chain output {
		type filter hook output priority 0;
		policy accept;
		ct state established,related accept;
	}
}
table inet nat {
	chain postrouting {
		type nat hook postrouting priority 100;
		policy accept;
		ip saddr { 10.10.10.0/24, 10.20.20.0/24, 10.30.30.0/24, 10.40.40.0/28, 10.50.50.0/24 } oifname "eth1" masquerade;	
	}
}
NFT

nft -f /etc/nftables.conf
