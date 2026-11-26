#!/bin/bash
while read b; do curl -s -m 10 -o /dev/null -w "%{http_code} $b\n" "https://$b.s3.amazonaws.com/"; done < buckets-wordlist.txt | grep -E '^(2..|3..|403) ' | awk '{print $2}' | head -1
