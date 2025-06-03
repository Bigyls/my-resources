# ----- Visual changes ----- #
sed -i 's/"%m"/"${HOSTNAME#exegol-}"/g' /opt/.exegol_shells_rc

# ----- Update and upgrade packages ----- #
apt update && apt upgrade

# ----- Run services ----- #
neo4j start

# ----- Install and configure dnsmasq ----- #
apt install -y dnsmasq

sed -i \
  -e 's/^#conf-dir=\/etc\/dnsmasq.d/conf-dir=\/etc\/dnsmasq.d/' \
  -e 's/^#port=5353/port=53/' \
  -e 's/^#listen-address=.*/listen-address=127.0.0.1/' \
  -e 's/^#no-resolv/no-resolv/' \
  /etc/dnsmasq.conf

echo 'server=1.1.1.1' >> /etc/dnsmasq.conf

echo 'nameserver 127.0.0.1' > /etc/resolv.conf

dnsmasq
