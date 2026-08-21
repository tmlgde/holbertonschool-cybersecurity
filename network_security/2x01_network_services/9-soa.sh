#!/bin/bash
dig +short -t SOA "$1" | awk '{print $1}'
