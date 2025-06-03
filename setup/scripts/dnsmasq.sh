#!/bin/bash

set -e

cp "$(dirname "$0")/../dnsmasq/dnsmasq.conf" /etc/dnsmasq.conf

cp "$(dirname "$0")/../dnsmasq/hosts" /etc/hosts

sed -i "s#exegol-xxx#$(hostname)#" "$(dirname "$0")/../dnsmasq/resolv.conf"
cp "$(dirname "$0")/../dnsmasq/resolv.conf" /etc/resolv.conf

dnsmasq
