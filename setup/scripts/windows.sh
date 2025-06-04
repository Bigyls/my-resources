#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%F %T')] $*"; }

for cmd in git; do
  command -v "$cmd" >/dev/null 2>&1 || { echo "Error: $cmd not found."; exit 1; }
done

log "Cloning Ghostpack-CompiledBinaries if needed..."
if [ ! -d /opt/resources/windows/Ghostpack-CompiledBinaries ]; then
    git clone --depth 1 https://github.com/r3motecontrol/Ghostpack-CompiledBinaries /opt/resources/windows/Ghostpack-CompiledBinaries
fi
