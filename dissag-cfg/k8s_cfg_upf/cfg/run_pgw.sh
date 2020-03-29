#!/bin/sh

echo "Waiting for " ${MONGODB_STARTUP_TIME} "s for mongodb to be ready..."
sleep ${MONGODB_STARTUP_TIME}

if ! grep "ogstun" /proc/net/dev > /dev/null; then
    ip tuntap add name ogstun mode tun
fi
ip addr del 45.45.0.1/16 dev ogstun 2> /dev/null
ip addr add 45.45.0.1/16 dev ogstun

ip link set ogstun up
iptables -P FORWARD ACCEPT
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -I INPUT -i ogstun -j ACCEPT

# masquerade
sh -c "sysctl net.ipv4.ip_forward=1"

touch /var/log/open5gs/pgw.log

tail -f /var/log/open5gs/pgw.log &

/bin/open5gs-pgwd -c /etc/open5gs/pgw.yaml
