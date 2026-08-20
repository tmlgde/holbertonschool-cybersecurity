#!/bin/bash
grep "localhost" /etc/hosts | head -n1 | awk '{printf "%s", $1}'
