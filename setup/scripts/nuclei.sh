#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%F %T')] $*"; }

for cmd in git nuclei; do
  command -v "$cmd" >/dev/null 2>&1 || { echo "Error: $cmd not found."; exit 1; }
done

TEMPLATES_DIR="$(dirname "$0")/../nuclei/templates"

log "Cloning custom-nuclei-templates if needed..."
if [ ! -d "$TEMPLATES_DIR/custom-nuclei-templates" ]; then
    git clone --depth 1 https://github.com/mdube99/custom-nuclei-templates "$TEMPLATES_DIR/custom-nuclei-templates"
fi

log "Cloning juicyinfo-nuclei-templates if needed..."
if [ ! -d "$TEMPLATES_DIR/juicyinfo-nuclei-templates" ]; then
    git clone --depth 1 https://github.com/cipher387/juicyinfo-nuclei-templates "$TEMPLATES_DIR/juicyinfo-nuclei-templates"
fi

log "Validating templates..."
for template in "$TEMPLATES_DIR"/*/*.yaml; do
    if [[ -f "$template" ]]; then
        nuclei -validate-template "$template"
    fi
done
