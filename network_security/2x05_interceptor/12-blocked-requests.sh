#!/bin/bash
sudo cat /var/log/squid/access.log | grep 403 | awk '{print $1, $3, $7}'
