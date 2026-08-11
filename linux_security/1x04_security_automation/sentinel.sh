#!/bin/bash
[ ! -f sentinel.conf ] && { echo "Config file missing"; exit 1; }; source sentinel.conf; [ -z "${SERVICES[*]}" ] && { echo "SERVICES not defined"; exit 1; }; [ -z "${FILES_TO_WATCH[*]}" ] && { echo "FILES_TO_WATCH not defined"; exit 1; }; echo "Config loaded successfully"

check_services() {
	for svc in "${SERVICES[@]}"; do
		if pgrep -f "$svc" &>/dev/null; then
			echo "OK: $svc is running"
		else
			if eval "$svc"; then
				echo "FIXED: Restarted $svc"
			else
				echo "ERROR: Failed to restart $svc"
			fi
		fi
	done
}
check_services
