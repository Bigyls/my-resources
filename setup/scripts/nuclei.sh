#!/bin/bash

set -euo pipefail
source "$(dirname "$0")/helpers/logs.sh"

TEMPLATES_DIR="$(dirname "$0")/../nuclei/templates"

log LOG "Cloning custom-nuclei-templates if needed..."
if [ ! -d "$TEMPLATES_DIR/custom-nuclei-templates" ]; then
    git clone --depth 1 https://github.com/mdube99/custom-nuclei-templates "$TEMPLATES_DIR/custom-nuclei-templates"
fi

log LOG "Cloning juicyinfo-nuclei-templates if needed..."
if [ ! -d "$TEMPLATES_DIR/juicyinfo-nuclei-templates" ]; then
    git clone --depth 1 https://github.com/cipher387/juicyinfo-nuclei-templates "$TEMPLATES_DIR/juicyinfo-nuclei-templates"
fi

log LOG "Validating templates..."
for template in "$TEMPLATES_DIR"/*/*.yaml; do
    if [[ -f "$template" ]]; then
        nuclei -update-templates -t "$template"
    fi
done

log LOG "Cleanning nuclei tmp folders..."
rm -rf /tmp/nuclei*
