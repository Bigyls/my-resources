#!/bin/bash

set -e

# Remove Firefox extensions and bookmark installed by Exegol
rm -f /root/.mozilla/firefox/*.Exegol/extensions/*
rm -f /root/.mozilla/firefox/*.Exegol/places.sqlite

# Apply Firefox policy
cp $(dirname "$0")/../firefox/policies.json /usr/lib/firefox-esr/distribution/ 
