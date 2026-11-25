#!/bin/bash
echo | openssl s_client -connect portal.astralis-cloud.example:443 -servername portal.astralis-cloud.example 2>/dev/null | openssl x509 -noout -text | grep -oE 'DNS:[^,]+' | grep -E 'internal|backend|admin|mgmt' | sed 's/DNS://' | head -1
