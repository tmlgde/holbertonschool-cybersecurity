#!/bin/bash
curl -sk https://portal.astralis-cloud.example/robots.txt | grep "Disallow:" | grep -iE 'admin|manage|backend|console' | head -1 | awk '{print $2}'
