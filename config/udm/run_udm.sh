#!/bin/sh

touch /var/log/open5gs/udm.log
tail -f /var/log/open5gs/udm.log &

/open5gs/install/bin/open5gs-udmd -c /etc/open5gs/udm.yaml
