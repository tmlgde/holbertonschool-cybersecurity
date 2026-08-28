#!/bin/bash
sudo tcpdump -i eth0 -w test27.pcap &
sudo nmap -sS -p 22,23,80 "$1"
