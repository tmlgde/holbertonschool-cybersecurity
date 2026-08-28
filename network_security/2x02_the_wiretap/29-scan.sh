#!/bin/bash
sudo tcpdump -i eth0 -w test29.pcap &
sudo nmap -sV -p 80 "$1"
