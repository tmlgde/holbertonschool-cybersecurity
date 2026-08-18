#!/bin/bash
bits=$(printf "%${1}s" | tr ' ' '1')$( printf "%$((32-$1))s" | tr ' ' '0'); printf "%d.%d.%d.%d\n" $(echo "ibase=2;${bits:0:8}"|bc) $(echo "ibase=2;${bits:8:8}"|bc) $(echo "ibase=2;${bits:16:8}"|bc) $(echo "ibase=2;${bits:24:8}"|bc)
