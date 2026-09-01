#!/bin/bash
tshark -r "$1" -Y "http.request.method == \"POST\" and (http.file_data contains \"password\" or http.file_data contains \"pass\" or http.file_data contains \"pwd\")" | sort -u
