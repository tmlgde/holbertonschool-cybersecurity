#!/bin/bash
for s in internal internal-svc backend backend-svc admin admin-svc; do dig +short "$s.astralis-cloud.example" | grep -q . && echo "$s.astralis-cloud.example"; sleep 1; done | grep internal
