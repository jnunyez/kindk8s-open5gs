#!/bin/sh

touch /var/log/open5gs/ausfm.log
tail -f /var/log/open5gs/ausfm.log &

/bin/open5gs-ausfd -c /etc/open5gs/ausfm.yaml
