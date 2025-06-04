#!/bin/bash

set -euo pipefail
source "$(dirname "$0")/scripts/helpers/logs.sh"

# Define paths
SETUP_DIR="$(dirname "$0")"
MAKEFILE="$SETUP_DIR/Makefile"
LOG_FILE="$SETUP_DIR/setup.log"
ERROR_LOG="/workspace/error.log"

# Get number of CPU cores
NUM_CORES=$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)

# Check if Makefile exists
if [ ! -f "$MAKEFILE" ]; then
    log ERROR "Makefile not found at $MAKEFILE"
    echo "Error: Makefile not found at $MAKEFILE" >> "$ERROR_LOG"
    exit 1
fi

log START "Starting setup process"
log START "Using Makefile at: $MAKEFILE"
log INFO "Running with $NUM_CORES parallel jobs"

# Run make with error handling and detailed output
if ! make -C "$SETUP_DIR" -k -j "$NUM_CORES" 2>&1 | tee -a "$LOG_FILE"; then
    log ERROR "Make command failed. Check $LOG_FILE for details"
    log ERROR "Last 10 lines of log:"
    tail -n 10 "$LOG_FILE" | while read -r line; do
        log ERROR "$line"
        echo "$line" >> "$ERROR_LOG"
    done
    echo "Setup process failed. See $LOG_FILE for full details." >> "$ERROR_LOG"
    exit 1
fi

log SUCCESS "Setup completed successfully"
log END "Setup process finished"
