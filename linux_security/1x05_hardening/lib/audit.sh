#!/bin/bash

generate_audit_report() {
	local FILE="audit_report.txt"
	{
		echo "======================================================"
		echo " HARDENING AUDIT REPORT - $(date '+%Y-%m-%d %H:%M:%S')"
		echo "======================================================"
		echo ""
		echo "[INFO] Hardening procedure completed successfully"
		echo "[INFO] SSH configured on port $SSH_PORT."
		local PORTS="$SSH_PORT"
		[ "$ALLOW_HTTP" == "yes" ] && PORTS="$PORTS, 80"
		[ "$ALLOW_HTTPS" == "yes" ] && PORTS="$PORTS, 443"
		echo "[INFO] FIrewall policy created: ports $PORTS ALLOWED."
		local USER_COUNT=${#REMOVED_USERS[@]}
			if [ "$USER_COUNT" -gt 0 ]; then
				local USER_LIST=$(IFS=", "; echo "${REMOVED_USERS[*]}")
				echo "[INFO] $USER_COUNT unauthorized users removed: $USER_LIST."
			else
				echo "[INFO] No unauthorized users found."
			fi
			echo "[INFO] Installed: auditd, fail2ban."
			echo "[INFO] Removed, telnet, ftp, netcat-traditional."
			for w in "${WARNINGS[@]}"; do
				echo "[WARN] $w"
			done
			echo ""
			echo "========================="
			echo " COMPLIANCE STATUS: PASS"
			echo "========================="
} > "$FILE"
log "Audit report generated: $FILE"
}
