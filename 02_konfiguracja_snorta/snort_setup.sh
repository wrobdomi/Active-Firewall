#!/bin/bash
echo "Configuring SNORT..."
rm /etc/snort/snort.conf
cp ./snort_konf/snort.conf /etc/snort/snort.conf
echo "Configuring detection rules..."
rm /etc/snort/rules/local.rules
cp ./snort_konf/local.rules /etc/snort/rules/local.rules
