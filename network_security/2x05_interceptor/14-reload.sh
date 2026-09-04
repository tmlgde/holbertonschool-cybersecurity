#!/bin/bash
sudo squid -k parse && sudo systemctl reload squid || echo "error restart"
