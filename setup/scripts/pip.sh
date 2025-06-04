#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%F %T')] $*"; }

for cmd in pip3 pipx; do
  command -v "$cmd" >/dev/null 2>&1 || { echo "Error: $cmd not found."; exit 1; }
done

log "Installing hekatomb with pip3..."
pip3 install --user hekatomb

log "Installing tools with pipx..."
pipx install ghunt
pipx install secator
pipx install git+https://github.com/nccgroup/GTFOBLookup 
