#!/bin/bash
sudo cat /var/log/squid/access.log | awk '{print $7}' | sed -E 's#https?://##; s#[/:].*##' | sort | uniq -c | sort -rn | head -10
