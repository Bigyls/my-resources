#!/bin/bash

set -euo pipefail
source "$(dirname "$0")/helpers/logs.sh"

log LOG "Cloning Ghostpack-CompiledBinaries if needed..."
if [ ! -d /opt/resources/windows/Ghostpack-CompiledBinaries ]; then
    git clone --depth 1 https://github.com/r3motecontrol/Ghostpack-CompiledBinaries /opt/resources/windows/Ghostpack-CompiledBinaries
fi
