#!/bin/bash
traceroute -n "$1" | tail -n +2 | wc -l
