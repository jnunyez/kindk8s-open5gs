# docker-open5gs

a repo with different open5gs configs in terms of dissagregation to instantiate customized epcs based on open5gs

## Rationale

This repo contains the docker builder and configuration of open5gs. More info of this opensource EPC can be found at [open5gs](https://open5gs.org)


## Folder structure

There is an optional ansible-playbook to install docker and docker-requirements in your baremetal/VM of choice.

```
- ./playbook.yml
```

Inside `config-` folder you can find the neccessary configs to launch the containeirezed OPEN5GS.
Each of the configs has associated a different `docker-compose` file. We considered different choices:

1.  Light EPC. Only the MME is active. This is to be used in case we only need to test the SCTP and S1AP connection between antenna and the MME.

```
- ./config-light/
docker-compose-light.yml
```

2. All the elmennts of the EPC in one container. Ideal for quick end-to-end test. 

```
- ./config-allinone/
docker-compose-allinone.yml
```


3. Microservice-based EPC. A folder with the specific open5gs config for each of the element of the EPC col.located in a container.

```
- ./config-ext
docker-compose.ext.yml
```

## Network setup

- Using macvlan network driver to expose epc entities to external elements (iperf server, antenna etc)

## Usage

Select your config of choice and build the container:

```
docker-compose up -f composefile build --no-cache
docker-compose up -d
```

## TODO

- Improve the doc
- Add more EPC configs (For instance a fully dissagregated EPC with dual NICs in some of their elements) 
- Add e2e telco network (UE+eNodeB)
