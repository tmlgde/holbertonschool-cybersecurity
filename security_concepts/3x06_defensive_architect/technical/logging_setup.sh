#!/bin/bash

set -e

RSYSLOG_CONF="/etc/rsyslog.d/60-forward.conf"
AUDIT_RULES="/etc/audit/rules.d/hardening.rules"

configure_rsyslog() {
	echo "Configuring rsyslog forwarding..."

	echo "*.* @@10.0.2.50:514" > "$RSYSLOG_CONF"

	systemctl restart rsyslog
}

configure_auditd() {
	echo "Configuring auditd rules..."
	{
		echo "-w /etc/passwd -p wa -k identity"
                echo "-w /etc/shadow -p wa -k identity"
                echo "-w /etc/sudoers -p wa -k privilege_escalation"
                echo "-w /etc/sudoers.d/ -p wa -k privilege_escalation"
                echo "-w /etc/ssh/sshd_config -p wa -k sshd_config_changes"
                echo "-w /var/log/nginx -p wa -k log_tampering"
                echo "-a always,exit -F arch=b64 -S execve -F euid=0 -k privileged_commands"
                echo "-e 2"
        } > "$AUDIT_RULES"
	
	augenrules --load
}

main() {
	configure_rsyslog
	configure_auditd
}
main
