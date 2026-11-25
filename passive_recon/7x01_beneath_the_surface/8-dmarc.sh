#!/bin/bash
dig +short TXT _dmarc.astralis-cloud.example | grep -oE 'p=[^;]+' | cut -d= -f2 | tr -d ' "'
