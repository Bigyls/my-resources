#!/bin/bash

set -e

if [ ! -d "$(dirname "$0")/../nuclei/templates/custom-nuclei-templates" ]; then
    git clone https://github.com/mdube99/custom-nuclei-templates "$(dirname "$0")/../nuclei/templates/custom-nuclei-templates"
fi

if [ ! -d "$(dirname "$0")/../nuclei/templates/juicyinfo-nuclei-templates" ]; then
    git clone https://github.com/cipher387/juicyinfo-nuclei-templates "$(dirname "$0")/../nuclei/templates/juicyinfo-nuclei-templates"
fi

for template in "$(dirname "$0")/../nuclei/templates/*/*.yaml"; do
    if [[ -f "$template" ]]; then
        nuclei -validate-template "$template"
    fi
done
