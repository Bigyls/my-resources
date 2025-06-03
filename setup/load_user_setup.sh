#!/bin/bash
set -e

# This script will be executed on the first startup of each new container with the "my-resources" feature enabled.
# Arbitrary code can be added in this file, in order to customize Exegol (dependency installation, configuration file copy, etc).
# It is strongly advised **not** to overwrite the configuration files provided by exegol (e.g. /root/.zshrc, /opt/.exegol_aliases, ...), official updates will not be applied otherwise.

# Exegol also features a set of supported customization a user can make.
# The /opt/supported_setups.md file lists the supported configurations that can be made easily.

# ----- Visual changes ----- #
sed -i 's/"%m"/"${HOSTNAME#exegol-}"/g' /opt/.exegol_shells_rc
ln -sf /opt/lists/rockyou.txt /opt/rockyou.txt

# ----- Install sources list keys ----- #
wget https://archive.kali.org/archive-keyring.gpg -O /usr/share/keyrings/kali-archive-keyring.gpg

# ----- Update, upgrade and install packages ----- #
apt update && apt upgrade

apt install -y \
  dnsmasq \
  nikto

# ----- Run services ----- #
neo4j start

# ----- Configure SSH ----- #

[ ! -d ~/.ssh ] && mkdir ~/.ssh
chmod -R 750 ~/.ssh
cp /opt/my-resources/setup/ssh/config ~/.ssh/config

# ----- Configure NetExec ----- #

cp -r /opt/my-resources/setup/nxc/nxc.conf ~/.nxc/nxc.conf

# ----- Configure dnsmasq ----- #

sed -i \
  -e 's/^#conf-dir=\/etc\/dnsmasq.d/conf-dir=\/etc\/dnsmasq.d/' \
  -e 's/^#port=5353/port=53/' \
  -e 's/^#listen-address=.*/listen-address=127.0.0.1/' \
  -e 's/^#no-resolv/no-resolv/' \
  /etc/dnsmasq.conf

echo 'server=1.1.1.1' >> /etc/dnsmasq.conf

echo 'nameserver 127.0.0.1' > /etc/resolv.conf

dnsmasq
