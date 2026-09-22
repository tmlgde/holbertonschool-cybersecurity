#!/bin/bash

set -e

WEB_SERVER_IP="10.0.1.10"
BASTION_IP="10.0.0.5"

configure_firewall() {
	echo "Resetting UFW rules..."
	ufw --force reset

	echo "Setting default deny policy..."
	ufw default deny incoming
	ufw default allow outgoing

	echo "Allowing SSH from bastion host only..."
	ufw allow from "$BASTION_IP" to any port 22

	echo " Allowing db from web server host only..."
	ufw allow from "$WEB_SERVER_IP" to any port 5432

	echo "Enabling UFW..."
	ufw --force enable
}

configure_firewall
