# docker-open5gs

a repo with different open5gs configs in terms of dissagregation to instantiate customized 5gc based on open5gs

## Rationale

This repo contains the docker builder and configuration of open5gs. More info of this opensource 5GC can be found at [open5gs](https://open5gs.org)


## Folder structure

Here we decompose a little bit the tools and subfolders of the repo.

### Some Pre-requirements

1. To run this deployment you need docker and docker-compose tools previously installed. 

2. Depending on your configuration some microservices in the 5GC must be externally accessible from the physical network (e.g., phy antenna connecting to MME or SGW). 

3. IP Forwarding must be activated in the host for the UPF to route traffic to Internet.

4. Build base image. To build the base image run the following command:

   ```
   docker build --no-cache --tag open5gs_base:version . 
   ```

### 5GC Configs

Inside `config` folders you can find the neccessary configs to launch the containeirezed 5G-C.

1. Microservice-based 5G-C. A folder with the specific open5gs config for each of the element of the EPC col.located in a container. Ideal to start playing with lifecycle management of each of the 5G-C. The actual deployment deploys sgwc, sgwu, nrf, smf, hss, mongodb, webui, upf, and mme.

In the `config` subfolder you can find the freeDiameter configuration for all microservices needing it (hss, pcrf, and smf) in the following subfolder:

   ```
   - ./config/freeDiameter
   ```

Subfolder for each microservice typically contains a `.yaml` file with the specific config and a script that acts as entrypoint for the container. For example:

   ```
   - ./config/mme
   ```

2. Microservice-based 5G-C for k8s. Specific configs of open5gs microservice to
   be deployed for each element of the EPC. TBA.


## Usage

Select your config of choice and build and run the container:

   ```
   docker-compose -f docker-compose.yml build --no-cache
   docker-compose up -d
   ```

## Debugging

TBA


## ToDo


- Add virtual UE+eNodeB (default route in UE has to be added manunally)

