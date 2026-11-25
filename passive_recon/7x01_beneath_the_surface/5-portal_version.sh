#!/bin/bash
curl -sI https://portal.astralis-cloud.example | grep -i '^server:' | awk '{print $2}' | tr -d '\r'
