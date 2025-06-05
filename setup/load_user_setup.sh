#!/bin/bash

set -euo pipefail
source "$(dirname "$0")/scripts/helpers/logs.sh"

# Configuration
readonly SETUP_DIR="$(dirname "$0")"
readonly MAKEFILE="$SETUP_DIR/Makefile"
readonly LOG_FILE="$SETUP_DIR/setup.log"
readonly ERROR_LOG="/workspace/error.log"
readonly NUM_CORES=$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)

# Functions
check_prerequisites() {
    if [ ! -f "$MAKEFILE" ]; then
        log ERROR "Makefile not found at $MAKEFILE"
        echo "Error: Makefile not found at $MAKEFILE" >> "$ERROR_LOG"
        return 1
    fi
    return 0
}

run_setup() {
    log START "Starting setup process"
    log START "Using Makefile at: $MAKEFILE"
    log INFO "Running with $NUM_CORES parallel jobs"

    if ! make -C "$SETUP_DIR" -k -j "$NUM_CORES" 2>&1 | tee -a "$LOG_FILE"; then
        log ERROR "Make command failed. Check $LOG_FILE for details"
        log ERROR "Last 10 lines of log:"
        tail -n 10 "$LOG_FILE" | while read -r line; do
            log ERROR "$line"
            echo "$line" >> "$ERROR_LOG"
        done
        echo "Setup process failed. See $LOG_FILE for full details." >> "$ERROR_LOG"
        return 1
    fi
    return 0
}

# Main execution
main() {
    check_prerequisites || exit 1
    run_setup || exit 1
    log SUCCESS "Setup completed successfully"
    log END "Setup process finished"
}

main
