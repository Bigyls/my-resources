#!/bin/bash

set -e

cp "$(dirname "$0")/../dnsmasq/dnsmasq.conf" /etc/dnsmasq.conf

echo -e "0.250.250.254\t\thost.docker.internal" >> /etc/hosts

echo -e "nameserver 127.0.0.1\nnameserver 0.250.250.200" > /etc/resolv.conf

dnsmasq
