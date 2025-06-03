#!/bin/bash

set -e

# This script delegates setup to feature scripts in setup/scripts/ for better organization
LOG_FILE="$(dirname "$0")/setup.log"

echo "==== Setup started at $(date) ====" >> "$LOG_FILE"

for script in $(dirname "$0")/scripts/*.sh; do
  echo "[START] $(date) $script" >> "$LOG_FILE"
  bash "$script" 2>&1 | tee -a "$LOG_FILE"
  
  if [ "${PIPESTATUS[0]}" -eq 0 ]; then
    echo "[SUCCESS] $(date) $script" >> "$LOG_FILE"
  else
    echo "[ERROR] $(date) $script" >> "$LOG_FILE"
    exit 1
  fi
  echo "[END] $(date) $script" >> "$LOG_FILE"
done

echo "==== Setup finished at $(date) ====" >> "$LOG_FILE"
