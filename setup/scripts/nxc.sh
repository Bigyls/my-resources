#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%F %T')] $*"; }

for cmd in cp mkdir; do
  command -v "$cmd" >/dev/null 2>&1 || { echo "Error: $cmd not found."; exit 1; }
done

log "Creating ~/.nxc directory..."
mkdir -p ~/.nxc
log "Copying nxc.conf..."
cp "$(dirname "$0")/../nxc/nxc.conf" ~/.nxc/nxc.conf 
