#!/bin/bash
grep -h $1 /var/log/kern.log /var/log/messages 2>/dev/null
