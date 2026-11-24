#!/bin/bash
dig NS astralis-cloud.example +short | sort | head -n1 | sed 's/\.$//'
