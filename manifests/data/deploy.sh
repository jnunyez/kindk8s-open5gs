#!/bin/bash

set -e

kubectl create -f pvol-cfg.yaml
kubectl create -f open5gs-claim0-persistentvolumeclaim.yaml

kubectl create -f pvol-diame.yaml
kubectl create -f open5gs-claim1-persistentvolumeclaim.yaml

kubectl create -f pvol-logs.yaml
kubectl create -f open5gs-claim2-persistentvolumeclaim.yaml

#ukubectl create -f webui-deployment.yaml
#kubectl create -f webui-service.yaml
