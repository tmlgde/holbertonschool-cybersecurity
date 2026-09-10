#!/bin/bash
if [ "$EUID" -ne 0 ]; then
	echo "This script must be run as root."
	exit 1
fi

sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
passwd -l telnetd
rm /etc/cron.d/logicorp
service ssh  restart
