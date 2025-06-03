#!/bin/bash

set -e

sed -i \
  -e 's/^#conf-dir=\/etc\/dnsmasq.d/conf-dir=\/etc\/dnsmasq.d/' \
  -e 's/^#port=5353/port=53/' \
  -e 's/^#listen-address=.*/listen-address=127.0.0.1/' \
  -e 's/^#no-resolv/no-resolv/' \
  /etc/dnsmasq.conf

echo 'server=1.1.1.1' >> /etc/dnsmasq.conf
echo 'nameserver 127.0.0.1' > /etc/resolv.conf

dnsmasq 
