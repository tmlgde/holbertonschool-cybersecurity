#!/bin/bash
scp skeleton.conf engineer@192.168.1.79: && ssh engineer@192.168.1.79 "./2-panic.sh && sudo nft -f skeleton.conf && sudo nft list ruleset" 
