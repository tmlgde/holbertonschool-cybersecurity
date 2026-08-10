#!/bin/bash
lsof -iTCP:$1 -sTCP:LISTEN -n | awk 'NR==2{print $1}'
