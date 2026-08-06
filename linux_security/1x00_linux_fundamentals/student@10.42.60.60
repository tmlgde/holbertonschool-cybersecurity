#!/bin/bash

mkdir -p "$1"
chown root:"$2" "$1"
chmod 2750 "$1"

cat > /etc/logrotate.d/app << EOF
$1/*.log {
	create 0640 root $2
}
EOF
