# example for all-in-one 1ip
sudo ip link add link eno1 name eno1.100 type vlan id 100
sudo ip addr add 172.30.2.1/24 brd 172.30.2.255 dev eno1.100
sudo ip link set dev eno1.100 up
sudo docker network create -d macvlan --subnet=172.30.2.0/24 --gateway=172.30.2.1 -o parent=eno1.100 physical

# exmaple for more than one ip
docker network create -d macvlan --subnet=10.15.16.0/24 --gateway=10.15.16.1 -o parent=eno1.666 s1c
docker network create -d macvlan --subnet=10.15.17.0/24 --gateway=10.15.17.1 -o parent=eno1.667 s1u
