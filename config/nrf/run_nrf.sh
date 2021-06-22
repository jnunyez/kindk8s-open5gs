#!/bin/sh


echo "Launching NRF..."

touch /var/log/open5gs/nrf.log

tail -f /var/log/open5gs/nrf.log &

/open5gs/install/bin/open5gs-nrfd -c /etc/open5gs/nrf.yaml
