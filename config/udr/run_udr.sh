#!/bin/sh

touch /var/log/open5gs/udr.log
tail -f /var/log/open5gs/udr.log &

/open5gs/install/bin/open5gs-udrd -c /etc/open5gs/udr.yaml
