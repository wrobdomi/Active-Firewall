#!/bin/bash

sudo snort -d -l /var/log/snort/ -A console -c /etc/snort/snort.conf | sudo ./py/active_firewall.py
