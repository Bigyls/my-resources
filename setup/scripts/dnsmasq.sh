#!/bin/bash

set -euo pipefail
source "$(dirname "$0")/helpers/logs.sh"

log INFO "Copying dnsmasq.conf..."
    cp "$(dirname "$0")/../dnsmasq/dnsmasq.conf" /etc/dnsmasq.conf

log INFO "Adding host.docker.internal to /etc/hosts..."
    echo -e "0.250.250.254\t\thost.docker.internal" >> /etc/hosts

log INFO "Setting /etc/resolv.conf..."
    echo -e "nameserver 127.0.0.1\nnameserver 0.250.250.200" > /etc/resolv.conf

log INFO "Starting dnsmasq..."
    dnsmasq
