#!/bin/bash
touch /etc/logrotate.d/secure_remote
cat << EOF > /etc/logrotate.d/secure_remote
/var/log/secure_remote.log {
daily
rotate 7
compress
missingok
}
EOF
