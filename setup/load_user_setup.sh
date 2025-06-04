#!/bin/bash

START_TIME=$(date +%s)

LOG_FILE="$(dirname "$0")/setup.log"
ERROR_LOG="/workspace/error.log"
SCRIPTS_DIR="$(dirname "$0")/scripts"

echo "==== Setup started at $(date) ====" > "$LOG_FILE"

pids=()
script_logfiles=()
script_names=()

# Clean up temp files on exit
cleanup() {
  for logfile in "${script_logfiles[@]:-}"; do
    [[ -f "$logfile" ]] && rm -f "$logfile"
  done
}
trap cleanup EXIT

shopt -s nullglob
scripts=("$SCRIPTS_DIR"/*.sh)
shopt -u nullglob

if [ ${#scripts[@]} -eq 0 ]; then
  echo "No scripts found in $SCRIPTS_DIR" | tee -a "$LOG_FILE"
  exit 0
fi

for script in "${scripts[@]}"; do
  logfile=$(mktemp /tmp/setup_script_log.XXXXXX)
  script_logfiles+=("$logfile")
  script_names+=("$script")
  echo "Executing $(basename "$script"). See logs in $logfile" >> "$LOG_FILE"
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
  logfile=${script_logfiles[$i]}
  if ! wait "$pid"; then
    echo "An error occurred while executing $(basename "$script"). Check $logfile for details." | tee -a "$ERROR_LOG"
    cat "$logfile" >> "$ERROR_LOG"
  fi
done

# Concatenate logs in order
for logfile in "${script_logfiles[@]}"; do
  cat "$logfile" >> "$LOG_FILE"
  rm -f "$logfile"
done

END_TIME=$(date +%s)
ELAPSED=$((END_TIME - START_TIME))

echo "==== Setup finished at $(date) ====" >> "$LOG_FILE"
echo "==== Elapsed time: ${ELAPSED} seconds ====" >> "$LOG_FILE"
