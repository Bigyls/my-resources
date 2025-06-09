#!/bin/bash

set -euo pipefail
source "$(dirname "$0")/helpers/logs.sh"

log LOG "Creating ~/.nxc directory..."
mkdir -p ~/.nxc
log LOG "Copying nxc.conf..."
cp "$(dirname "$0")/../nxc/nxc.conf" ~/.nxc/nxc.conf 
