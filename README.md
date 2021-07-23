# kindk8s-open5gs

a repo with different open5gs configs in terms of dissagregation to instantiate customized 5gc based on open5gs

## Rationale

This repo contains an example deployment of [open5gs](https://open5gs.org) in k8s using [kind](https://kind.sigs.k8s.io). More info of this opensource 5GC can be found at [open5gs](https://open5gs.org)

## Quickstart


1. Deploy kind k8s cluster composed by one control plane and three workers and attach a local image registry

   ```
   deploy-cluster
   ```

2. Deploy mongodb cluster. A mongodb cluster with three replicas that will act as backend for the open5gs core network.

   ```
   deploy-mongodb
   ```

3. Deploy certificates for open5gs components requiring diameter authentication (used by hss, mme, pcrf and smf):

   ```
   deploy-certificates
   ``` 

4. Deploy open5gs

   ```
   deploy-open5gs
   ```

## Folder structure

Here we decompose a little bit the tools and subfolders of the repo.


## Deployment Strategy


### Certificates and Diameter

As some of the services composing open5gs require diameter protocol authentication, the deployment needs to self-generate some certificates. In particular HSS, MME, PCRF, and SMF are using certificates. The certificates are gathered as secrets from the k8s and mounted during deployment in `/etc/tls`. These certificates are deployed k8s using the cert manager. To check that the certificates are present run `kubectl get certificate` and expect a very similar output as the one below:

```
NAME   READY   SECRET   AGE
hss    True    hss      30m
mme    True    mme      30m
pcrf   True    pcrf     30m
smf    True    smf      30m
```

### MongoDB K8s operator

The HSS and UDM are using as backend mongodb to store subscriber information. We use [mongoDB-operator](https://github.com/mongodb/mongodb-kubernetes-operator) to deploy three replicas sets of mongodb (since we are deploying three workers).
Before deploying open5gs components to check that the mongodb operator has been deployed run`kubectl get mongodbcommunity` and expect a very similar ouput as the one below: 

```
NAME              PHASE     VERSION
open5gs-mongodb   Running  
```

### Open5Gs components

We use the same base image for all open5gs components. At deployment time we inject different `.yaml`configuration files to each open5gs microservice  by means of configmap. Also we use a config map to mount diameter configuration for the hss, smf, mme, and pcrf. After running the deployment of open5gs we recomment to check that all pods are running eventually. Expect a very similar output as the one below after running `kubectl get pods`:

```
NAME                                          READY   STATUS    RESTARTS   AGE
amf-d5975b77b-nndh6                           1/1     Running   3          41m
ausf-799db46f87-nzthd                         1/1     Running   3          41m
bsf-6b8cf6cb55-787tg                          1/1     Running   3          41m
hss-6cd4d9b7b6-znsmf                          1/1     Running   0          41m
mme-79cbb9d965-qdmzs                          1/1     Running   4          41m
mongodb-kubernetes-operator-957dff59d-tgpgr   1/1     Running   0          82m
nrf-776d87bb5d-2vj7p                          1/1     Running   0          41m
nssf-67c5f6df78-x4lv5                         1/1     Running   3          41m
open5gs-mongodb-0                             2/2     Running   0          82m
open5gs-mongodb-1                             2/2     Running   0          80m
open5gs-mongodb-2                             2/2     Running   0          79m
pcf-7d749b98bf-884d5                          1/1     Running   3          41m
pcrf-5dffd6c689-kmhdf                         1/1     Running   4          41m
sgwc-74c9f94664-s64jt                         1/1     Running   3          41m
sgwu-694ddffd-tkkzp                           1/1     Running   0          41m
smf-76f648f58-f96f7                           1/1     Running   3          41m
udm-7549c55f5b-hc889                          1/1     Running   3          41m
udr-f748b7465-hk8bv                           1/1     Running   3          41m
upf-75fcf5dc7-g6vkc                           1/1     Running   0          41m
webui-d7797f598-b48jb                         1/1     Running   0          41m
```