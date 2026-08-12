#!/bin/bash
grep -h segfault /var/log/kern.log /var/log/messages 2>/dev/null
