#!/bin/bash
scp skeleton.conf engineer@10.5.3.47: && ssh engineer@10.5.3.47 "./2-panic.sh && sudo nft -f skeleton.conf && sudo nft list ruleset" 
