#!/bin/bash
touch /etc/rsyslog.conf
echo '$template json_fmt,"{\"time\":\"%timestamp%\", \"host\":\"%hostname%\", \"msg\":\"%msg%\"}"' >> /etc/rsyslog.conf
