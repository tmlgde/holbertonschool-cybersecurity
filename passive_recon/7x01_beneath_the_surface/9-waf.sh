#!/bin/bash
wafw00f https://portal.astralis-cloud.example 2>/dev/null | grep -oP 'is behind \K[^ (]+'
