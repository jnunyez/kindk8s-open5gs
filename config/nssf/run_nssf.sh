#!/bin/sh


echo "Launching NSSF..."

touch /var/log/open5gs/nssf.log

tail -f /var/log/open5gs/nssf.log &

/open5gs/install/bin/open5gs-nssfd -c /etc/open5gs/nssf.yaml
