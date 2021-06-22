#!/bin/sh

ip tuntap add name ogstun mode tun
ip addr add 45.45.0.1/16 dev ogstun
ip link set ogstun up

# masquerade
sh -c "sysctl net.ipv4.ip_forward=1"

iptables -t nat -A POSTROUTING -o ogstun -j MASQUERADE
iptables -I INPUT -i ogstun -j ACCEPT

touch /var/log/open5gs/pgw.log

tail -f /var/log/open5gs/pgw.log &

/bin/open5gs-upfd -c /etc/open5gs/pgw.yaml
