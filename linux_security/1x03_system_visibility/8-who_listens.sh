#!/bin/bash
lsof -i:$1 -sTCP:LISTEN | awk 'NR==2{print $1}'
