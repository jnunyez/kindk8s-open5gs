#!/bin/bash

set -e

kubectl create -f pvol-cfg.yaml
kubectl create -f web-claim0-persistentvolumeclaim.yaml

kubectl create -f pvol-logs.yaml
kubectl create -f web-claim1-persistentvolumeclaim.yaml

kubectl create -f webui-deployment.yaml
kubectl create -f webui-service.yaml