#!/bin/sh

if ! grep "ogstun" /proc/net/dev > /dev/null; then
    ip tuntap add name ogstun mode tun
fi
ip addr del 45.45.0.1/16 dev ogstun 2> /dev/null
ip addr add 45.45.0.1/16 dev ogstun
#ip addr del cafe::1/64 dev ogstun 2> /dev/null
#ip addr add cafe::1/64 dev ogstun

ip r del default via 192.168.50.1
ip r add default via 172.30.0.1


ip link set ogstun up
iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE
iptables -I INPUT -i ogstun -j ACCEPT
