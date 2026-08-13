#!/bin/bash
cp sentinel.timer sentinel.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable --now sentinel.timer
