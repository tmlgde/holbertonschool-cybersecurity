#!/bin/bash
tcpdump -i eth0 -w test26.pcap &
nmap -sT -p 22,23,80 "$1"
