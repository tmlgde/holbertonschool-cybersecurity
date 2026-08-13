#!/bin/bash
cp sentinel.timer /etc/systemd/system/
cp sentinel.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable sentinel.timer
systemctl start sentinel.timer
