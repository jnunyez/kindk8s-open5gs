# docker-open5gs

a repo with different open5gs configs in terms of dissagregation to instantiate customized epcs based on open5gs

## Rationale

This repo contains the docker builder and configuration of open5gs. More info of this opensource EPC can be found at [open5gs](https://open5gs.org)


## Folder structure

Here we decompose a little bit the tools and subfolders of the repo.

### Some Pre-requirements

1. To run the open5gs you need docker and docker-compose tools. There is an optional ansible-playbook called `playbook.yml` to install docker and docker-requirements in your Linux baremetal/VM of choice. This playbook has only been tested on Ubuntu 18.04

2. Depending on your configuration some services in the EPC must be externally accessible from the physical network (e.g., phy antenna connecting to MME or SGW). For this purpose we use macvlan driver in our configurations so that every container interface appears as a `physical` interfaces accessible from the physical network. An example of bash script used to create docker macvlan networks for the S1C and S1U connection in our configs can be found in `create-net.sh`

3. IP Forwarding must be activated in the host for the P-GW to route traffic to Internet.

### EPC configs

Inside `config-` folders you can find the neccessary configs to launch the containeirezed OPEN5GS.
Each of the configs has associated a different `docker-compose` file. We considered different choices:

1.  Light EPC. Only the MME is active (ideal as starting point) This is to be used in case we only need to test the SCTP and S1AP connection between antenna and the MME.

```
- ./config-light/
docker-compose-light.yml
```

2. Allinone EPC: All the elements of the EPC in one container (no dissagregation here). An additional container for the DB appliance (mongo-db) and another one for the front-end dashboard of the db. Ideal for a quickly having a full EPC to test. 

```
- ./config-allinone/
docker-compose-allinone.yml
```

3. Allinone EPC with one IP address: "allinone-1ip": Allinone-1ip, all the elements of the EPC in one container
   (no dissagregation here). The main difference with the previous one is that
   only 1 IP address is exposed at S1 level.

```
- ./config-allinone-1ip/
docker-compose-allinone.yml
```


4. Microservice-based EPC. A folder with the specific open5gs config for each of the element of the EPC col.located in a container. Ideal to start playing with lifecycle management of each of the EPC services.

```
- ./config-diss/
docker-compose-diss.yml
```

5. Microservice-based EPC for k8s. Specific configs of open5gs microservice to
   be deployed for each element of the EPC. Ideal to start playing with k8s and
   open5gs.

All the previous configs are using macvlan network driver to expose epc entities to external elements (iperf server, antenna etc)

## Usage

Select your config of choice and build and run the container:

```
docker-compose -f compose_file build --no-cache
docker-compose up -d
```

## Debugging

To check that the EPC is working take a logs at the logs dumped by the container:

```
docker logs open5gs_epc -f
2/24 11:25:39.991: [mme] INFO: eNB-S1 accepted[10.15.16.9]:51015 in s1_path module (../src/mme/s1ap-sctp.c:109)
12/24 11:25:39.991: [mme] INFO: eNB-S1 accepted[10.15.16.9] in master_sm module (../src/mme/mme-sm.c:167)
12/24 11:25:39.992: [mme] INFO: Added a eNB. Number of eNBs is now 1 (../src/mme/mme-context.c:68)
12/24 11:26:04.355: [mme] INFO: Added a UE. Number of UEs is now 1 (../src/mme/mme-context.c:58)
12/24 11:26:04.420: [mme] INFO: Added a session. Number of sessions is now 1 (../src/mme/mme-context.c:79)
12/24 11:26:04.456: [pgw] INFO: UE IMSI:[001010000000001] APN:[internet] IPv4:[45.45.0.3] IPv6:[] (../src/pgw/pgw-context.c:845)
12/24 11:26:04.456: [pgw] INFO: Added a session. Number of active sessions is now 1 (../src/pgw/pgw-context.c:40)
```

From the UE (in this case we are using an emulated vUE running in a docker container) you can initiate some traffic flow to the default GW specified in the P-GW ogstun interface:

```
docker exec -u 0 -it ue bash -c "ping 45.45.0.1"
PING 45.45.0.1 (45.45.0.1) 56(84) bytes of data.
64 bytes from 45.45.0.1: icmp_seq=1 ttl=64 time=35.8 ms
64 bytes from 45.45.0.1: icmp_seq=2 ttl=64 time=35.2 ms
64 bytes from 45.45.0.1: icmp_seq=3 ttl=64 time=34.6 ms
```


## ToDo

- Add more EPC configs (For instance a fully dissagregated EPC with dual NICs in some of their elements) 

- Add virtual UE+eNodeB (default route in UE has to be added manunally)

- Add example using IPv6 scenario.
