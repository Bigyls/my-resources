#!/bin/bash

set -euo pipefail
source "$(dirname "$0")/helpers/logs.sh"

log INFO "Installing tools with pip3..."
pip3 install --user hekatomb

log INFO "Installing tools with pipx..."
pipx install ghunt
pipx install secator
pipx install git+https://github.com/nccgroup/GTFOBLookup
