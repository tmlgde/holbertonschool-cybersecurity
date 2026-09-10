#!/bin/bash
if [ $EUID -ne 0 ]; then
	echo "This script must be run as root."
	exit 1
fi

mkdir -p /etc/wireguard
cd /etc/wireguard
wg genkey | tee server_private.key | wg pubkey > server_public.key
wg genkey | tee admin_private.key | wg pubkey > admin_public.key
wg genkey | tee finance_private.key | wg pubkey > finance_public.key

SERVER_PRIV=$(< "server_private.key")
SERVER_PUB=$(< "server_public.key")
ADMIN_PRIV=$(< "admin_private.key")
ADMIN_PUB=$(< "admin_public.key")
FINANCE_PRIV=$(< "finance_private.key")
FINANCE_PUB=$(< "finance_public.key")

cat > wg0.conf << EOF
[Interface]
Address = 10.10.10.1/24
ListenPort = 51820
PrivateKey = $SERVER_PRIV

[Peer]
PublicKey = $ADMIN_PUB
AllowedIPs = 10.10.10.2/32

[Peer]
PublicKey = $FINANCE_PUB
AllowedIPs = 10.10.10.3/32

EOF

cat > admin.conf << EOF
[Interface]
Address = 10.10.10.2/32
PrivateKey = $ADMIN_PRIV

[Peer]
PublicKey = $SERVER_PUB
AllowedIPs = 10.30.30.50/32
Endpoint = <GATEWAY_PUBLIC_IP>:51820

EOF

cat > finance.conf << EOF
[Interface]
Address = 10.10.10.3/32
PrivateKey = $FINANCE_PRIV

[Peer]
PublicKey = $SERVER_PUB
AllowedIPs = 10.20.20.10/32
Endpoint = <GATEWAY_PUBLIC_IP>:51820

EOF

wg-quick up wg0
