#!/bin/bash
tshark -r "$1" -Y "http.request.uri contains \"UNION\" or http.request.uri contains \"SELECT\"" -T fields -e ip.src -e http.request.uri | sort -u
