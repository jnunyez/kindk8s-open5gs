#!/bin/sh

touch /var/log/open5gs/amf.log
tail -f /var/log/open5gs/amf.log &

/open5gs/install/bin/open5gs-amfd -c /etc/open5gs/amf.yaml
