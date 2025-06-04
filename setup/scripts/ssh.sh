#!/bin/bash

set -euo pipefail
source "$(dirname "$0")/helpers/logs.sh"

log LOG "Ensuring ~/.ssh directory exists with correct permissions..."
install -d -m 750 ~/.ssh

log LOG "Copying SSH config..."
cp "$(dirname "$0")/../ssh/config" ~/.ssh/config 
