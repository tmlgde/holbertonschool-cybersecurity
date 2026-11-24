#!/bin/bash
dig SOA astralis-cloud.example +short | awk '{print $1}' | sed 's/\.$//'
