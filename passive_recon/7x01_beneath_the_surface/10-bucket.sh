#!/bin/bash
for s in prod dev backup backups data assets static media logs prod-eu prod-eu-west storage files; do curl -s -m 10 -o /dev/null -w "%{http_code} astralis-$s\n" "https://astralis-$s.s3.amazonaws.com/"; done | grep -E '^(200|301|302|307|403) ' | awk '{print $2}' | head -1
