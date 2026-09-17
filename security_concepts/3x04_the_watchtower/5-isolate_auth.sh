#!/bin/bash
touch /etc/rsyslog.d/60-auth.conf
echo "authpriv.info /var/log/secure_remote.log" >> /etc/rsyslog.d/60-auth.conf
service rsyslog restart
