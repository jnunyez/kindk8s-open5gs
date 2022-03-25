# ocp-open5gs

Manifests and data examples to deploy open5gs in Red Hat OpenShift.

## Rationale

This repo contains an example deployment of [open5gs](https://open5gs.org) in Red Hat OpenShift container platform. More info of this opensource 5GC can be found at [open5gs](https://open5gs.org)

## Quickstart


1. Deploy [mongodb community operator](https://github.com/mongodb/mongodb-kubernetes-operator). A mongodb cluster with three replicas that will act as backend for the open5gs core network. Currently, we use a privileged service account to mount as root some persistent volumes via nfs in mongodb-agents.

   ```console
   deploy-mongodb
   ```

2. Deploy certificates for open5gs components requiring diameter authentication. The HSS, MME, PCRF and the SMF are the entities requiring a certifacate that use diameter AAA protocol. The command below deploys cert-manager operator to ultimately generate the required secrets for the HSS, MME, PCRF, and SMF. A service account necessary to associate to all the subsequent deployments is also created.

   ```console
   deploy-certificates
   ``` 

3. Deploy open5gs components. 

   ```console
   deploy-open5gs
   ```

4. Uninstall open5gs components. Note that this does not uninstall mongodb operator. 

   ```console
   destroy-open5gs
   ```

5. Uninstall mongodb operator and database replicas. The command below will uninstall mongodb community operator and mongo DBs. The command below needs to be executed after the open5gs components have been uninstalled with the command in previou step.
   
   ```console
   destroy-mongodb
   ```

## Deployment Strategy

### Component Configuration

* We use Kustomize configMapGenerator to generate ConfigMap from files for each Open5gs component. The configmaps generated will be consumed by each of the deployment associated to every open5gs component (i.e., Config Data--->Kustomize-->Configmaps). 

* The data stored in the configmaps populate Volume objects inside the different deployments for every open5gs component. Every open5gs component will create one pod composed by one container.


### Certificates and Diameter

As some of the services composing open5gs require diameter protocol authentication, the deployment needs to self-generate some certificates. In particular HSS, MME, PCRF, and SMF are using certificates. The certificates are gathered as secrets and mounted during deployment in `/etc/tls`. These certificates are deployed using the cert manager. To check that the certificates are present run `kubectl get certificate` and expect a very similar output as the one below:

```console
NAME   READY   SECRET   AGE
hss    True    hss      30m
mme    True    mme      30m
pcrf   True    pcrf     30m
smf    True    smf      30m
```

### MongoDB operator

The HSS and UDM are using as backend mongodb to store subscriber information. We use [mongoDB-operator](https://github.com/mongodb/mongodb-kubernetes-operator) to deploy three replicas sets of mongodb (since we are deploying three workers).
Before deploying open5gs components to check that the mongodb operator has been deployed run `oc get mongodbcommunity` and expect a very similar ouput as the one below: 

```console
NAME              PHASE     VERSION
open5gs-mongodb   Running  
```

### Open5Gs components

We use the same base image for all open5gs components. At deployment time we inject different `.yaml`configuration files to each open5gs microservice  by means of configmap. Also we use a config map to mount diameter configuration for the hss, smf, mme, and pcrf. After running the deployment of open5gs we recomment to check that all pods are running eventually. Expect a very similar output as the one below after running `oc get pods`:

```console
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


## Open5GS external services

### Webui

The `webui` pod running inside the kubernetes cluster is used to register subscriber information. To expose this service externally we use a NodePort. 

```console
kubectl get svc webui-svc
NAME        TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
webui-svc   NodePort   10.96.59.136   <none>        3000:30030/TCP   2m 
```

The service is accessible in cluster in port 30030. To remotely access the service exposed in the node port you can port forward to your localhost.

```console
ssh -L 3000:K8S_NODE_IP:30030 username@HOST_IP
```

You should be able to access the web service in your localhost at port 3000, e.g., `curl localhost:3000`.
