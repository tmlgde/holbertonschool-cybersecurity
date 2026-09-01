#!/bin/bash
tshark -r "$1" -Y "ip.addr == 172.16.42.66" -T fields -e frame.time | head -n 1; tshark -r "$1" -Y "ip.addr == 172.16.42.66" -T fields -e frame.time | tail -n 1
