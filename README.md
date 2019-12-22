# docker-open5gs

a repo with different open5gs configs in terms of dissagregation to instantiate customized epcs based on open5gs

## Rationale

This repo contains the docker builder and configuration of open5gs. More info of this opensource EPC can be found at [open5gs](https://open5gs.org)


## Folder structure

Here we decompose a little bit the tools and subfolders of the repo.

### Some Pre-requirements

1. To run the open5gs you need docker and docker-compose tools. There is an optional ansible-playbook called `playbook.yml` to install docker and docker-requirements in your Linux baremetal/VM of choice. This playbook has only been tested on Ubuntu 18.04

2. Depending on your configuration some services in the EPC must be externally accessible from the physical network (e.g., phy antenna connecting to MME or SGW). For this purpose we use macvlan driver in our configurations so that every container interface appears as a `physical` interfaces accessible from the physical network. An example of bash script used to create docker macvlan networks for the S1C and S1U connection in our configs can be found in `create-net.sh`

### EPC configs

Inside `config-` folders you can find the neccessary configs to launch the containeirezed OPEN5GS.
Each of the configs has associated a different `docker-compose` file. We considered different choices:

1.  Light EPC. Only the MME is active (ideal as starting point) This is to be used in case we only need to test the SCTP and S1AP connection between antenna and the MME.

```
- ./config-light/
docker-compose-light.yml
```

2. ALL-IN-ONE EPC: All the elments of the EPC in one container (no dissagregation here). Ideal for a quickly having a full EPC to test.

```
- ./config-allinone/
docker-compose-allinone.yml
```


3. Microservice-based EPC. A folder with the specific open5gs config for each of the element of the EPC col.located in a container. Ideal to start playing with lifecycle management of each of the EPC services.

```
- ./config-diss/
docker-compose-diss.yml
```


All the previouse configs are using macvlan network driver to expose epc entities to external elements (iperf server, antenna etc)

## Usage

Select your config of choice and build and run the container:

```
docker-compose -f compose_file build --no-cache
docker-compose up -d
```

## TODO

- Add more EPC configs (For instance a fully dissagregated EPC with dual NICs in some of their elements) 
- Add virtual UE+eNodeB 
