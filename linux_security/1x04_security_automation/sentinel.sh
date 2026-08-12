#!/bin/bash
[ ! -f sentinel.conf ] && { echo "Config file missing"; exit 1; }; source sentinel.conf; [ -z "${SERVICES[*]}" ] && { echo "SERVICES not defined"; exit 1; }; [ -z "${FILES_TO_WATCH[*]}" ] && { echo "FILES_TO_WATCH not defined"; exit 1; }; echo "Config loaded successfully"

check_services() {
	for svc in "${SERVICES[@]}"; do
		if pgrep -f "$svc" &>/dev/null; then
			log "SERVICE" "$svc" "OK: $svc is running"
		else
			if eval "$svc"; then
				log "SERVICE" "$svc" "FIXED: Restarted"
			else
				log "SERVICE" "$svc"  "ALERT: Failed to restart $svc"
			fi
		fi
	done
}

check_integrity() {
	for file in "${FILES_TO_WATCH[@]}"; do
		live_hash=$(md5sum $file | awk '{print $1}')
		golden="/var/backups/sentinel/$(basename "$file").gold"
		golden_hash=$(md5sum $golden | awk '{print $1}')
		if [ "$golden_hash" == "$live_hash" ]; then
			log "INTEGRITY" "$file" "OK: Integrity verified"
		else
			cp "$golden" "$file"
			log "INTEGRITY" "$file" "FIXED: Restored file"
		fi
	done
}

check_ports() {
	for port in $(ss -lnt4 | awk 'NR>1{split($4,a,":"); print a[2]}'); do
		allowed=false
		for p in "${ALLOWED_PORTS[@]}"; do
			if [ "$port" == "$p" ]; then
				allowed=true
			fi
		done
		if [ "$allowed" == false ]; then
			pid=$(losf -iTCP:$port -sTCP\:LISTEN -n -P | awk '{print $1}')
			kill -9 $pid
			log "PORT" "$port" "ALERT: Killed rogue process on port"
		fi
	done
}

log() {
	local component="$1"
	local target="$2"
	local status="$3"
	local details="$4"
	local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
	echo "{\"timestamp\": \"$timestamp\", \"component\": \"$component\",\"target\": \"$target\", \"status\": \"$status\", \"details\": \"$details\"}" >> /var/log/sentinel.log
}

check_ports
check_integrity
check_services
