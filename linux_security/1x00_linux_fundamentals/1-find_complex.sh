#!/bin/bash
find "$1" -size +1M ! "*.gz" -type f -mtime -7 2>/dev/null
