#!/bin/bash

# Logs are stored in the /var/log/exegol/load_user_setup.log file (https://docs.exegol.com/images/my-resources#troubleshooting)

# Path to the error log file
ERROR_LOG_FILE="/workspace/error.log"
# Directory containing all setup scripts
SCRIPTS_DIR="$(dirname "$0")/scripts"

# Source the logging helper functions
source "$SCRIPTS_DIR/helpers/logs.sh"

# Arrays to keep track of background process IDs, temporary log files, and script names
pids=()
tmp_script_logfiles=()
script_names=()

# Cleanup function to remove temporary log files on exit
cleanup() {
  log INFO "Cleaning up temporary log files..."
  for tmp_logfile in "${tmp_script_logfiles[@]:-}"; do
    [[ -f "$tmp_logfile" ]] && rm -f "$tmp_logfile"
  done
}
# Ensure cleanup runs on script exit
trap cleanup EXIT

# Enable nullglob so that the scripts array is empty if no files match
shopt -s nullglob
scripts=("$SCRIPTS_DIR"/*.sh)
shopt -u nullglob

# Exit if no scripts are found
if [ ${#scripts[@]} -eq 0 ]; then
  log ERROR "No scripts found in $SCRIPTS_DIR"
  exit 0
fi

# Loop through each setup script and run it in the background, logging output to a temp file
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

# Wait for all background scripts to finish and collect errors if any
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

# Concatenate all temporary log files in order and remove them
for tmp_logfile in "${tmp_script_logfiles[@]}"; do
  cat "$tmp_logfile"
  echo -e "\n------\n"
  rm -f "$tmp_logfile"
done
