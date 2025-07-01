#!/bin/bash

set -euo pipefail
source "$(dirname "$0")/helpers/logs.sh"

log INFO "Ensuring ~/.ssh directory exists with correct permissions..."
install -d -m 750 ~/.ssh

log INFO "Copying SSH config..."
cp "$(dirname "$0")/../ssh/config" ~/.ssh/config
