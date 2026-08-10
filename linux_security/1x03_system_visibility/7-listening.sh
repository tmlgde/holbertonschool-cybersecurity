#!/bin/bash
ss -tln4 | awk 'NR>1{print $4}' | awk -F: '{print $2}'
