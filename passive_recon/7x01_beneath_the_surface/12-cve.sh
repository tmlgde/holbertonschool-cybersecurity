#!/bin/bash
curl -s -m 25 "https://services.nvd.nist.gov/rest/json/cves/2.0?cpeName=cpe:2.3:a:nginx:nginx:$(curl -s --head https://portal.astralis-cloud.example | grep -i '^server:' | awk -F/ '{print $2}' | tr -d '\r '):*:*:*:*:*:*:*" | jq -r '.vulnerabilities[] | [(.cve.metrics.cvssMetricV31[0].cvssData.baseScore // 0), .cve.id] | @tsv' | sort -rn | head -1 | cut -f2
