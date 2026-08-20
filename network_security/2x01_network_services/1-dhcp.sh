#!/bin/bash
nmcli -f DHCP4 device show $(ip route show default | awk '{print $5}') | grep dhcp_server_identifier | awk '{print $4}'
