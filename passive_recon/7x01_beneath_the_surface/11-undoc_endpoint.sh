#!/bin/bash
for u in $(curl -sk https://status.astralis-cloud.example/api/v2/summary.json | jq -r '.components[].check' | grep -vf <(curl -sk https://api.astralis-cloud.example/v1/docs/openapi.json | jq -r '.paths|keys[]')); do curl -sk -o /dev/null -w '%{http_code}' "$u" | grep -qE '^(200|301|302|401|403)$' && echo "$u"; done | head -1
