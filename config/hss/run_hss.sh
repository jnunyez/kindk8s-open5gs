#!/bin/sh

echo "Waiting for " ${MONGODB_STARTUP_TIME} "s for mongodb to be ready..."
sleep ${MONGODB_STARTUP_TIME}

echo "Launching HSS..."

touch /var/log/open5gs/hss.log

tail -f /var/log/open5gs/hss.log &


#sed -i 's|HSS_IP|'172.30.1.4'|g' /etc/open5gs/hss.conf
#sed -i 's|MME_IP|'172.30.1.5'|g' /etc/open5gs/hss.conf
#sed -i 's|EPC_DOMAIN|'epc.mnc001.mcc01.3gppnetwork.org'|g' /etc/open5gs/hss.conf
#sed -i 's|EPC_DOMAIN|'epc.mnc001.mcc01.3gppnetwork.org'|g' /etc/open5gs/make_certs.sh

sleep 36000 
/open5gs/install/bin/open5gs-hssd -c /etc/open5gs/hss.yaml
