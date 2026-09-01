#!/bin/bash
mkdir carved; tshark -r "$1" --export-objects http,carved; md5sum carved/*
