kubectl apply -f sgw-deployment.yaml 
sleep 2
kubectl apply -f service-sgw.yaml
sleep 10
kubectl apply -f pgw-deployment.yaml 
sleep 10
kubectl apply -f pcrf-deployment.yaml
