#!/bin/bash
tail -f /var/log/auth.log | grep "sudo" | grep "authentication failure" |
	while read line; do
		echo "ALERT: Sudo violation detected!"
	done
