#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%F %T')] $*"; }

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root." >&2
  exit 1
fi

for cmd in wget apt-get; do
  command -v "$cmd" >/dev/null 2>&1 || { echo "Error: $cmd not found."; exit 1; }
done

log "Downloading Kali archive keyring..."
wget https://archive.kali.org/archive-keyring.gpg -O /usr/share/keyrings/kali-archive-keyring.gpg

log "Updating package lists..."
apt-get update

log "Installing packages..."
apt-get install -y \
  dnsmasq \
  nikto \
  snmp-mibs-downloader 
