#!/bin/bash
sed -i -E 's/^#?PermitRootLogin.*/PermitRootLogin no/' "$1"
sed -i -E 's/^#?PasswordAuthentication.*/PasswordAuthentication no/' "$1"
sed -i -E 's/^#?PubkeyAuthentication.*/PubkeyAuthentication yes/' "$1"
