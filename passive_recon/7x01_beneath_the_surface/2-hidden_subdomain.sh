#!/bin/bash
while read s; do dig +short "$s.astralis-cloud.example" | grep -q . && echo "$s.astralis-cloud.example"; sleep 1; done < wordlist.txt | grep -E 'internal|backend|admin' | head -1
