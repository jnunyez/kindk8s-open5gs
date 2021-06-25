#!/bin/sh

touch /var/log/open5gs/pcf.log

tail -f /var/log/open5gs/pcf.log &

/open5gs/install/bin/open5gs-pcfd -c /etc/open5gs/pcf.yaml
