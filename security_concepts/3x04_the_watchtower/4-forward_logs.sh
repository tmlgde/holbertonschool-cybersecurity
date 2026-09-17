#!/bin/bash
touch /etc/rsyslog.d/50-default.conf
echo "*.* @127.0.0.1" >> /etc/rsyslog.d/50-default.conf
service rsyslog restart
logger "Test Log Forwarding"
