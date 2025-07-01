#!/bin/bash

START_TIME=$(date +%s)

ERROR_LOG_FILE="/workspace/error.log"
SCRIPTS_DIR="$(dirname "$0")/scripts"

source "$SCRIPTS_DIR/helpers/logs.sh"

pids=()
tmp_script_logfiles=()
script_names=()

cleanup() {
  log INFO "Cleaning up temporary log files..."
  for tmp_logfile in "${tmp_script_logfiles[@]:-}"; do
    [[ -f "$tmp_logfile" ]] && rm -f "$tmp_logfile"
  done
}
trap cleanup EXIT

shopt -s nullglob
scripts=("$SCRIPTS_DIR"/*.sh)
shopt -u nullglob

if [ ${#scripts[@]} -eq 0 ]; then
  log ERROR "No scripts found in $SCRIPTS_DIR"
  exit 0
fi

for script in "${scripts[@]}"; do
  tmp_logfile=$(mktemp /tmp/setup.log.XXXXXX)
  tmp_script_logfiles+=("$tmp_logfile")
  script_names+=("$script")
  log INFO "Executing $(basename "$script") ..."
  (
    log START "$script"
    bash "$script"
    status=$?
    if [ $status -eq 0 ]; then
      log SUCCESS "$script"
    else
      log ERROR "$script"
    fi
    log END "$script"
    exit $status
  ) &> "$tmp_logfile" &
  pids+=($!)
done

# Wait for all scripts and collect errors
for i in "${!pids[@]}"; do
  pid=${pids[$i]}
  script=${script_names[$i]}
  tmp_logfile=${tmp_script_logfiles[$i]}
  if ! wait "$pid"; then
    log ERROR "An error occurred while executing $(basename "$script"). Check "$ERROR_LOG_FILE" for details."
    cat "$tmp_logfile" >> "$ERROR_LOG_FILE"
    echo -e "\n------\n" >> "$ERROR_LOG_FILE"
  fi
done

# Concatenate logs in order
for tmp_logfile in "${tmp_script_logfiles[@]}"; do
  cat "$tmp_logfile"
  echo -e "\n------\n"
  rm -f "$tmp_logfile"
done
