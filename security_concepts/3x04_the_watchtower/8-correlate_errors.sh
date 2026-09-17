#!/bin/bash
awk '$9 == 404 || $9 == 403 { print $1}' "$1" | sort | uniq -c | while read count ip; 
	do
		if [ "$count" -gt 5 ]; then
			echo "ALERT: IP $ip is scanning us!"
		fi
	done
