#!/bin/bash

set -euo pipefail
source "$(dirname "$0")/helpers/logs.sh"

log INFO "Cloning api_wordlist..."
    if [ ! -d /opt/lists/api_wordlist ]; then
        git clone --depth 1 https://github.com/chrislockard/api_wordlist /opt/lists/api_wordlist
        rm -rf /opt/lists/api_wordlist/.git /opt/lists/api_wordlist/README.md
    fi

log INFO "Downloading API documentation wordlist if needed..."
    if [ ! -f /opt/lists/api_wordlists/api-documentation-endpoint.txt ]; then
        wget -P /opt/lists/api_wordlists https://raw.githubusercontent.com/z5jt/API-documentation-Wordlist/refs/heads/main/API-Documentation-Wordlist/api-documentation-endpoint.txt
    fi

log INFO "Cloning statistically-likely-usernames..."
    if [ ! -d /opt/lists/statistically-likely-usernames ]; then
        git clone --depth 1 https://github.com/insidetrust/statistically-likely-usernames /opt/lists/statistically-likely-usernames
        rm -rf /opt/lists/statistically-likely-usernames/.git /opt/lists/statistically-likely-usernames/README.md
    fi
