#!/bin/bash
sudo tcpdump -i eth0 -w test29.pcap &
nmap -sV -p 80 "$1"
