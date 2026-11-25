#!/bin/bash
nmap -sT -T2 -p 49152-65535 admin.astralis-cloud.example | grep open | cut -d/ -f1
