#!/bin/bash
[ ! -f sentinel.conf ] && { echo "Config file missing"; exit 1; }; source sentinel.conf; [ -z "${SERVICES[*]}" ] && { echo "SERVICES not defined"; exit 1; }; [ -z "${FILES_TO_WATCH[*]}" ] && { echo "FILES_TO_WATCH not defined"; exit 1; }; echo "Config loaded successfully"
