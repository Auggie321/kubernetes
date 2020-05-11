prometheus-operator monitor kubernetes  

git clone https://github.com/coreos/kube-prometheus.git  
kubectl apply -f kube-prometheus/manifests/setup  
kubectl apply -f kube-prometheus/manifests  


## monitor kube-contronller and kube-scheduler, ingress-nginx, and discovery pod
```
apiVersion: v1
kind: Pod
metadata:
  annotations:
    prometheus.io/port: "10254"
    prometheus.io/scrape: "true"
```
netstat -tlnup|grep -E 'kube-sche|kube-cont|etcd'  
curl 127.0.0.1:port/metrics  
```
grep 0.0.0.0 -r /etc/systemd/system
/etc/systemd/system/kube-apiserver.service:  --insecure-bind-address=0.0.0.0 \  
/etc/systemd/system/kube-scheduler.service:  --address=0.0.0.0 \  
/etc/systemd/system/kube-scheduler.service:  --master=http://0.0.0.0:8080 \  
/etc/systemd/system/kube-controller-manager.service:  --address=0.0.0.0 \  
/etc/systemd/system/kube-controller-manager.service:  --master=http://0.0.0.0:8080 \  
systemctl daemon-reload && systemctl restart kube-apiserver, kube-scheduler, kube-controller-manager  
curl 192.168.2.xx:port/metrics
```
kubectl apply -f prometheus-clusterRole.yaml  
kubectl create secret generic additional-configs --from-file=prometheus-additional.yaml -n monitoring  
kubectl apply -f prometheus-prometheus.yaml  
kubectl apply -f prometheus-kubeControllerScheduler.yaml  
(ingress-nginx grafana_template_id:9614)  
## monitor etcd  
curl 127.0.0.1:2379/metrics  
curl --cacert /etc/kubernetes/ssl/ca.pem --cert /etc/etcd/ssl/etcd.pem --key /etc/etcd/ssl/etcd-key.pem https://192.168.2.143:2379/metrics  
kubectl -n monitoring create secret generic etcd-certs --from-file=/etc/kubernetes/ssl/ca.pem --from-file=/etc/etcd/ssl/etcd.pem --from-file=/etc/etcd/ssl/etcd-key.pem  
kubectl apply -f prometheus-prometheus.yaml  
```
nodeSelector:  
  beta.kubernetes.io/os: linux  
replicas: 2  
secrets:  
- etcd-certs  
```  
kubectl apply -f prometheus-serviceMonitorEtcd.yaml  
kubectl apply -f prometheus-etcdServiceEndpoints.yaml  





