# kind-open5gs

a repo with different open5gs configs in terms of dissagregation to instantiate customized 5gc based on open5gs

## Rationale

This repo contains an example deployment of [open5gs](https://open5gs.org) in k8s using [kind](https://kind.sigs.k8s.io). More info of this opensource 5GC can be found at [open5gs](https://open5gs.org)

## Quickstart


1. Deploy k8s cluster and local registry

   ```
   deploycluster.sh
   ```

2. Deploy mongodb cluster:

   ```
   deploy-mongodb
   ```

3. Deploy certificates for diameter authentication:

   ```
   deploy-certificates
   ``` 

4. Deploy open5gs

   ```
   deploy-open5gs
   ```

## Folder structure

Here we decompose a little bit the tools and subfolders of the repo.

### Some Pre-requirements

TBA


## Debugging

TBA


## ToDo


- Add virtual UE+eNodeB (default route in UE has to be added manunally)

