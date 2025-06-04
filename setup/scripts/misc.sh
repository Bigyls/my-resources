#!/bin/bash

set -e

sed -i 's/"%m"/"${HOSTNAME#exegol-}"/g' /opt/.exegol_shells_rc
cp /opt/lists/rockyou.txt /opt/lists/arockyou.txt

# Permissions fix
find /workspace/ -type d -exec chmod 770 {} \; -exec chmod g+s {} \;
find /workspace/ -type f -exec chmod 660 {} \;
