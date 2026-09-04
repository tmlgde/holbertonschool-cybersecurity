#!/bin/bash
sudo apt update && sudo apt install squid -y && sudo systemctl enable squid && sudo cp /etc/squid/squid.conf /etc/squid/squid.conf.bak
