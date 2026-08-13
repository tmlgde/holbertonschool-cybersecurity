#!/bin/bash

if [ "$EUID" -ne 0 ]; then
	echo "This script must be run as root. Exiting."
	exit 1
fi

log () {
	local message=$1
	echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" >> /var/log/hardening.log
}

source config/harden.cfg

log "Hardening framework initialized"

source lib/network.sh
source lib/ssh.sh
source lib/identity.sh
source lib/system.sh

configure_firewall_policy
harden_kernel
