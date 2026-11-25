#!/bin/bash
wafw00f https://portal.astralis-cloud.example -f json -o /dev/stdout 2>/dev/null | jq -r '.[0].firewall' | head -1 || curl -skI https://portal.astralis-cloud.example | grep -i 'X-Served-By' | awk '{print $2}' | tr -d '\r'
