echo "Launching SMF..."

touch /var/log/open5gs/smf.log

tail -f /var/log/open5gs/smf.log &


/open5gs/install/bin/open5gs-smfd -c /etc/open5gs/smf.yaml
