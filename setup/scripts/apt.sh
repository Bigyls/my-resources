#!/bin/bash

set -euo pipefail
source "$(dirname "$0")/helpers/logs.sh"

log LOG "Downloading Kali archive keyring..."
wget https://archive.kali.org/archive-keyring.gpg -O /usr/share/keyrings/kali-archive-keyring.gpg

log LOG "Updating package lists..."
apt-get update

log LOG "Installing packages..."
apt-get install -y \
  dnsmasq \
  nikto \
  snmp-mibs-downloader 
