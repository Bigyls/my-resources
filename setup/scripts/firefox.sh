#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%F %T')] $*"; }

for cmd in cp; do
  command -v "$cmd" >/dev/null 2>&1 || { echo "Error: $cmd not found."; exit 1; }
done

log "Removing Firefox extensions and bookmarks installed by Exegol..."
rm -f /root/.mozilla/firefox/*.Exegol/extensions/*
rm -f /root/.mozilla/firefox/*.Exegol/places.sqlite

log "Applying Firefox policy..."
cp "$(dirname "$0")/../firefox/policies.json" /usr/lib/firefox-esr/distribution/ 
