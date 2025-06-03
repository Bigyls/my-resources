#!/bin/bash

set -e

sed -i 's/"%m"/"${HOSTNAME#exegol-}"/g' /opt/.exegol_shells_rc
cp /opt/lists/rockyou.txt /opt/lists/arockyou.txt 
