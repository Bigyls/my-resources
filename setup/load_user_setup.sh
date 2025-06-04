#!/bin/bash

set -euo pipefail
source "$(dirname "$0")/scripts/helpers/logs.sh"

# Define paths
SETUP_DIR="$(dirname "$0")"
MAKEFILE="$SETUP_DIR/Makefile"
LOG_FILE="$SETUP_DIR/setup.log"
ERROR_LOG="/workspace/error.log"

# Check if Makefile exists
if [ ! -f "$MAKEFILE" ]; then
    log ERROR "Makefile not found at $MAKEFILE"
    exit 1
fi

log START "Starting setup process"
log START "Using Makefile at: $MAKEFILE"

# Run make with error handling and detailed output
if ! make -C "$SETUP_DIR" -k -j 4 --debug=v 2>&1 | tee -a "$LOG_FILE"; then
    log ERROR "Make command failed. Check $LOG_FILE for details"
    log ERROR "Last 10 lines of log:"
    tail -n 10 "$LOG_FILE" | while read -r line; do
        log ERROR "$line"
    done
    exit 1
fi

# Check if all targets were built successfully
if ! make -C "$SETUP_DIR" -q; then
    log ERROR "Some targets failed to build"
    log ERROR "Failed targets:"
    make -C "$SETUP_DIR" -k -j 4 --dry-run 2>&1 | grep -i "error\|fail" | while read -r line; do
        log ERROR "$line"
    done
    exit 1
fi

log SUCCESS "Setup completed successfully"
log END "Setup process finished"