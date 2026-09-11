#!/bin/bash

if [ $EUID -ne 0 ]; then 
	echo "This script must be run as root."
	exit 1
fi

TOTAL=0
PASS=0

check() {
	TOTAL=$((TOTAL+1))
	if [ "$2" -eq 0 ]; then
		echo "[PASS] $1"
		PASS=$((PASS+1))
	else
		echo "[FAIL] $1"
	fi 
}


nft list chain inet filter input | grep -q "policy drop"
check "Firewall default INPUT policy is DROP" $?
nft list chain inet filter forward | grep -q "policy drop"
check "Firewall default FORWARD policy is DROP" $?
nft list chain inet filter input | grep -q " udp dport 51820 accept"
check "udp dport 51820 is ACCEPT" $?
nft list chain inet nat postrouting | grep -q "masquerade"
check "NAT is configured" $?
COUNT=$(nft list chain inet filter forward | grep -c "accept")
[ "$COUNT" -eq 7 ]
check "7 rules accept on FORWARD" $?
service ssh status | grep -q "Active: active (running)"
check "SSH is RUNNING" $?
grep -q "PermitRootLogin no" /etc/ssh/sshd_config
check "RootLogin is NO" $?
grep -q "PasswordAuthentication no" /etc/ssh/sshd_config
check "PasswordAuthentication is NO" $?
grep -q "PubkeyAuthentication yes" /etc/ssh/sshd_config
check "PubkeyAuthentication is YES" $?
ip a show eth0 | grep -q "state UP"
check "WAN interface is UP" $?
ip route | grep -q "default via .* dev eth0"
check "Default route via WAN interface" $?
wg show | grep -q "interface: wg0"
check "VPN is RUNNING" $?
! ss -tln | grep ":23 "
check "Service telnet is stopped" $?
SUDO_MEMBERS=$(getent group sudo | cut -d: -f4)
[ "$SUDO_MEMBERS" = "tmlgde" ]
check "Only expected admins have root access" $?
sysctl net.ipv4.ip_forward | grep -q "net.ipv4.ip_forward = 1"
check "IP forwarding is ENABLED" $?
ip a show wg0 | grep -q "inet 10.10.10.1/24 scope global wg0"
check "Interface wg0 has correct address" $?
ip route | grep -q "10.10.10.0/24 dev wg0 proto kernel scope link src 10.10.10.1"
check "Routes are CORRECT" $?
echo "RESULT: $PASS/$TOTAL checks passed"
