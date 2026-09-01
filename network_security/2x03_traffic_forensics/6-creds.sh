#!/bin/bash
tshark -r "$1" -Y "urlencoded-form.key == \"password\" or urlencoded-form.key == \"pass\" or urlencoded-form.key == \"pwd\"" -T fields -e urlencoded-form.value | sort -u
