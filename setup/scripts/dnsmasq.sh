#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%F %T')] $*"; }

for cmd in cp dnsmasq; do
  command -v "$cmd" >/dev/null 2>&1 || { echo "Error: $cmd not found."; exit 1; }
done

log "Copying dnsmasq.conf..."
cp "$(dirname "$0")/../dnsmasq/dnsmasq.conf" /etc/dnsmasq.conf

log "Adding host.docker.internal to /etc/hosts..."
echo -e "0.250.250.254\t\thost.docker.internal" >> /etc/hosts

log "Setting /etc/resolv.conf..."
echo -e "nameserver 127.0.0.1\nnameserver 0.250.250.200" > /etc/resolv.conf

log "Starting dnsmasq..."
dnsmasq
