#!/bin/bash

set -e

wget https://archive.kali.org/archive-keyring.gpg -O /usr/share/keyrings/kali-archive-keyring.gpg

apt update

apt install -y \
  dnsmasq \
  nikto \
  snmp-mibs-downloader 
