#!/bin/bash
dig -4 +trace "$1" | grep "Received.*root-servers.net" | awk '{print $6}' | cut -d'#' -f1
