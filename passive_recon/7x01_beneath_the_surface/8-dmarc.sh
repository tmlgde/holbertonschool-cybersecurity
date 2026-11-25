#!/bin/bash
dig +short TXT _dmarc.astralis-cloud.example | grep -oE 'p=(none|quarantine|reject)' | cut -d= -f2 | tr -d ' "'
