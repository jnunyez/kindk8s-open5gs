#!/bin/sh


echo "Launching SGWC..."

touch /var/log/open5gs/sgwc.log

tail -f /var/log/open5gs/sgwc.log &

/open5gs/install/bin/open5gs-sgwcd -c /etc/open5gs/sgwc.yaml
