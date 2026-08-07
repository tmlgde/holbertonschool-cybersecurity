#!/bin/bash

dpkg -s "$1" &>/dev/null || apt-get install -y "$1"

if grep -q "pam_quality.so" "$2"; then
	sed -i 's/.*pam_pwquality\.so.*/password requisite pam_pwquality.so retry=3 minlen=12 minclass=3/' "$2"
else
	sed -i '/pam_unix.so/ i password requisite pam_pwquality.so retry=3 minless=12 miclass=3' "$2"
fi
