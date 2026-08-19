#!/bin/bash
line=$(ip addr show tun0 | grep "inet "); echo "$line" | awk '{print $2}' | cut -d'/' -f1
