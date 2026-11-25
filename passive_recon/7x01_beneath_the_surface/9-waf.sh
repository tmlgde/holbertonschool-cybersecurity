#!/bin/bash
curl -skI https://portal.astralis-cloud.example | wafw00f https://portal.astralis-cloud.example 2>/dev/null | grep -oP 'is behind \K[^ (]+' || curl -skI https://portal.astralis-cloud.example | grep -i 'X-Served-By' | awk '{print $2}' | tr -d '\r'
