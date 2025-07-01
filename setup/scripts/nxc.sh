#!/bin/bash

set -euo pipefail
source "$(dirname "$0")/helpers/logs.sh"

log INFO "Creating ~/.nxc directory..."
    mkdir -p ~/.nxc
log INFO "Copying nxc.conf..."
    cp "$(dirname "$0")/../nxc/nxc.conf" ~/.nxc/nxc.conf
