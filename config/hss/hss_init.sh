#!/bin/bash


export DB_URI="mongodb://${MONGO_IP}/open5gs"

export IP_ADDR=$(awk 'END{print $1}' /etc/hosts)

[ ${#MNC} == 3 ] && EPC_DOMAIN="epc.mnc${MNC}.mcc${MCC}.3gppnetwork.org" || EPC_DOMAIN="epc.mnc0${MNC}.mcc${MCC}.3gppnetwork.org"

cp /mnt/hss/hss.yaml install/etc/open5gs
cp /mnt/hss/hss.conf install/etc/freeDiameter
cp /mnt/hss/make_certs.sh install/etc/freeDiameter

sed -i 's|HSS_IP|'$HSS_IP'|g' install/etc/freeDiameter/hss.conf
sed -i 's|MME_IP|'$MME_IP'|g' install/etc/freeDiameter/hss.conf
sed -i 's|EPC_DOMAIN|'$EPC_DOMAIN'|g' install/etc/freeDiameter/hss.conf
sed -i 's|EPC_DOMAIN|'$EPC_DOMAIN'|g' install/etc/freeDiameter/make_certs.sh
sed -i 's|MONGO_IP|'$MONGO_IP'|g' install/etc/open5gs/hss.yaml

# Generate TLS certificates
./install/etc/freeDiameter/make_certs.sh install/etc/freeDiameter

# Sync docker time
#ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
