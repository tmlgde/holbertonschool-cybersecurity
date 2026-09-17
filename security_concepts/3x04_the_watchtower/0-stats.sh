#!/bin/bash
echo "File: /var/log/auth.log - Lines: $(wc -l < /var/log/auth.log)"
echo "File: /var/log/syslog - Lines: $(wc -l < /var/log/syslog)"
echo "File: /var/kern/auth.log - Lines: $(wc -l < /var/log/kern.log)"
