#!/bin/bash
awk '$8 == 404 || $8 == 403 { compteur[$1]++ } END {
	for (ip in compteur)
		if (compteur[ip] > 5) {
			print "ALERT: IP "ip" is scanning us!"
		}
}' "$1"
