#!/bin/sh

if ! grep "ogstun" /proc/net/dev > /dev/null; then
    ip tuntap add name ogstun mode tun
fi
ip addr del 45.45.0.1/16 dev ogstun 2> /dev/null
ip addr add 45.45.0.1/16 dev ogstun
#ip addr del cafe::1/64 dev ogstun 2> /dev/null
#ip addr add cafe::1/64 dev ogstun

ip link set ogstun up
sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -I INPUT -i ogstun -j ACCEPT

