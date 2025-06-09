#!/bin/bash

set -euo pipefail
source "$(dirname "$0")/helpers/logs.sh"

log LOG "Removing Firefox extensions and bookmarks installed by Exegol..."
rm -f /root/.mozilla/firefox/*.Exegol/extensions/*
rm -f /root/.mozilla/firefox/*.Exegol/places.sqlite

log LOG "Applying Firefox policy..."
cp "$(dirname "$0")/../firefox/policies.json" /usr/lib/firefox-esr/distribution/
