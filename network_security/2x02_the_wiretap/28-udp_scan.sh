#!/bin/bash
sudo tcpdump -i eth0 -w test28.pcap &
sudo nmap -sU -p 53,161 "$1"
