#!/bin/bash

echo "Checking for latest apt-get..."
apt-get update
echo "Installing snort dependencies..."
apt-get install licpcap-dev bison flex
echo "Installing snort..."
apt-get install snort

