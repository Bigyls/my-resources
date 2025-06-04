#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%F %T')] $*"; }

for cmd in cp mkdir chmod; do
  command -v "$cmd" >/dev/null 2>&1 || { echo "Error: $cmd not found."; exit 1; }
done

log "Ensuring ~/.ssh directory exists with correct permissions..."
install -d -m 750 ~/.ssh

log "Copying SSH config..."
cp "$(dirname "$0")/../ssh/config" ~/.ssh/config 
