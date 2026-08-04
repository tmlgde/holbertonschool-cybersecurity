#!/bin/bash
find "$1" -size +1M ! -name "*.gz" -type f -mtime -7 2>/dev/null
