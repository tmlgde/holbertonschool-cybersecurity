#!/bin/bash
grep "localhost" /etc/hosts | head -n1 | awk '{print $1}'
