#!/bin/bash
bits=$(printf "${1}s" |tr ' ' '1')$( printf "%$((32-$1))s" | tr ' ' '0')
