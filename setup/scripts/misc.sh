#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%F %T')] $*"; }

for cmd in sed cp find; do
  command -v "$cmd" >/dev/null 2>&1 || { echo "Error: $cmd not found."; exit 1; }
done

log "Updating /opt/.exegol_shells_rc..."
sed -i 's/"%m"/"${HOSTNAME#exegol-}"/g' /opt/.exegol_shells_rc

log "Copying rockyou.txt..."
cp /opt/lists/rockyou.txt /opt/lists/arockyou.txt

log "Fixing permissions in /workspace..."
find /workspace/ -type d -exec chmod 770 {} \; -exec chmod g+s {} \;
find /workspace/ -type f -exec chmod 660 {} \;
