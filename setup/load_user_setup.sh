#!/bin/bash

START_TIME=$(date +%s)

LOG_FILE="$(dirname "$0")/setup.log"
ERROR_LOG="/workspace/error.log"
SCRIPTS_DIR="$(dirname "$0")/scripts"

echo "==== Setup started at $(date) ====" > "$LOG_FILE"

pids=()
logfiles=()
script_names=()
for script in "$SCRIPTS_DIR"/*.sh; do
  logfile="$(mktemp)"
  logfiles+=("$logfile")
  script_names+=("$script")
  echo "Executing $script. See logs in $logfile" >> "$LOG_FILE"
  (
    echo "[START] $(date) $script"
    bash "$script"
    status=$?
    if [ $status -eq 0 ]; then
      echo "[SUCCESS] $(date) $script"
    else
      echo "[ERROR] $(date) $script"
    fi
    echo "[END] $(date) $script"
    exit $status
  ) &> "$logfile" &
  pids+=($!)
done

# Wait for all scripts and collect errors
for i in "${!pids[@]}"; do
  pid=${pids[$i]}
  script=${script_names[$i]}
  wait "$pid"
  status=$?
  if [ $status -ne 0 ]; then
    echo "An error occurred while executing $script. Check the $LOG_FILE file for details." >> "$ERROR_LOG"
  fi
done

# Concatenate logs in order
for logfile in "${logfiles[@]}"; do
  cat "$logfile" >> "$LOG_FILE"
  rm -f "$logfile"
done

END_TIME=$(date +%s)
ELAPSED=$((END_TIME - START_TIME))

echo "==== Setup finished at $(date) ====" >> "$LOG_FILE"
echo "==== Elapsed time: ${ELAPSED} seconds ====" >> "$LOG_FILE"
