#!/bin/sh

ip tuntap add name pgwtun mode tun
ip addr add 45.45.0.1/16 dev pgwtun
ip link set pgwtun up

# masquerade
sh -c "sysctl net.ipv4.ip_forward=1"

iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -I INPUT -i pgwtun -j ACCEPT

touch /var/log/open5gs/pgw.log

tail -f /var/log/open5gs/pgw.log &

/bin/open5gs-pgwd -c /etc/open5gs/pgw.yaml
