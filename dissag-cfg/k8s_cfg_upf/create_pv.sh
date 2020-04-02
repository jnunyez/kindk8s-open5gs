
kubectl create pv /opt/volA

kubectl create -f pvol-sgw.yaml 
kubectl create -f sgw-claim0-persistentvolumeclaim.yaml


kubectl create pv /opt/volB

kubectl create -f pvol-pcrf.yaml 
kubectl create -f pcrf-claim0-persistentvolumeclaim.yaml


kubectl create pv /opt/volC

kubectl create -f pvol-pgw.yaml 
kubectl create -f pgw-claim0-persistentvolumeclaim.yaml
