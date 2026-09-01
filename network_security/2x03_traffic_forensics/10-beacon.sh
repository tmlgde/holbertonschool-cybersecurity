#!/bin/bash
tshark -r "$1" -Y "ip.addr == 10.10.10.50 and ip.addr == 198.51.100.23" -T fields -e frame.time_relative
