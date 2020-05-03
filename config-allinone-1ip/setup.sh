#!/bin/sh


if ! grep "ogstun" /proc/net/dev > /dev/null; then
    ip tuntap add name ogstun mode tun
fi
ip addr del 45.45.0.1/16 dev ogstun 2> /dev/null
ip addr add 45.45.0.1/16 dev ogstun
#ip addr del cafe::1/64 dev ogstun 2> /dev/null
#ip addr add cafe::1/64 dev ogstun

# careful here customize according to your config here assuming 192.168.50.x is my net with dns/int access
ip r add default via 192.168.50.1  
ip r del default via 172.30.2.1

# Ensure with any release that eth0 is for private network and management and eth1 is the one of the s1ap
# Ensure that your container has access to the Internet otherwise Diameter will shutdown with:
# ERROR: ../subprojects/freeDiameter/libfdcore/server.c:184 ERROR: in '(fd_cnx_receive(c, &ts, &rcv_data.buffer, &rcv_data.length))' :	Connection timed out (../lib/diameter/common/init.c:116)

ip link set ogstun up
iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE
iptables -I INPUT -i ogstun -j ACCEPT
