#!/bin/bash

set -euo pipefail
source "$(dirname "$0")/helpers/logs.sh"

log LOG "Updating /opt/.exegol_shells_rc..."
sed -i 's/"%m"/"${HOSTNAME#exegol-}"/g' /opt/.exegol_shells_rc

log LOG "Copying rockyou.txt... for better fzf-wordlists"
cp /opt/lists/rockyou.txt /opt/lists/aaaaaaaaaaaaaa.txt

log LOG "Fixing permissions in /workspace..."
find /workspace/ -type d -exec chmod 770 {} \; -exec chmod g+s {} \;
find /workspace/ -type f -exec chmod 660 {} \;
