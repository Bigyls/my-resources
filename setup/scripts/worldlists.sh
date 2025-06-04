#!/bin/bash

set -e

# Web
git clone https://github.com/chrislockard/api_wordlist /opt/lists/api_wordlist
rm -rf /opt/lists/api_wordlist/.git /opt/lists/api_wordlist/README.md

if [ ! -f /opt/lists/api_wordlists/api-documentation-endpoint.txt ]; then
    wget -P /opt/lists/api_wordlists https://raw.githubusercontent.com/z5jt/API-documentation-Wordlist/refs/heads/main/API-Documentation-Wordlist/api-documentation-endpoint.txt
fi

# Usernames
git clone https://github.com/insidetrust/statistically-likely-usernames /opt/lists/statistically-likely-usernames
rm -rf /opt/lists/statistically-likely-usernames/.git /opt/lists/statistically-likely-usernames/README.md
