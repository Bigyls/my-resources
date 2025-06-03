#!/bin/bash

set -e

# Web

if [ ! -d /opt/lists/api_wordlist ]; then
  git clone https://github.com/chrislockard/api_wordlist /opt/lists/api_wordlist
fi

# Usernames

if [ ! -d /opt/lists/statistically-likely-usernames ]; then
  git clone https://github.com/insidetrust/statistically-likely-usernames /opt/lists/statistically-likely-usernames
fi
