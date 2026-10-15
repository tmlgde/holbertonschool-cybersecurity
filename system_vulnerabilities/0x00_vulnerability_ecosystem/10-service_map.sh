#!/bin/bash
echo "TCP Listeners:"
for port in $(sudo ss -tlnp | awk 'NR > 1 {print $4}' | awk -F: '{print $NF}' | sort -u); do
    service=$(grep -w "${port}/tcp" /etc/services | awk '{print $1}' | head -1)
    case "$service" in
        ssh) version=$(ssh -V 2>&1 | awk '{print $1}' | sed 's/_/ /') ;;
        http) version=$(apache2 -v 2>/dev/null | grep -o 'Apache/[0-9.]*') ;;
        mysql) version=$(mysql --version 2>/dev/null) ;;
        ftp) version=$(dpkg -l vsftpd 2>/dev/null | awk '/vsftpd/ {print "vsftpd " $3}') ;;
        *) version="" ;;
    esac
    echo "  ${port}/tcp    ${service}    ${version}"
done
echo "UDP Listeners:"
for port in $(sudo ss -ulnp | awk 'NR > 1 {print $4}' | awk -F: '{print $NF}' | sort -u); do
    service=$(grep -w "${port}/udp" /etc/services | awk '{print $1}' | head -1)
    echo "  ${port}/udp    ${service}"
done
echo "Enabled at boot: $(systemctl list-unit-files --type=service --state=enabled | awk '{print $1}' | grep '\.service' | sed 's/.service//' | paste -sd, | sed 's/,/, /g')"
