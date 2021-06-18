##### collects some rook ceph issues

```
## QuickStart
## if not checkout will face as following(crd version conflict): 
## Failed to list *v1beta1.Cluster: the server could not find the requested resource (get clusters.ceph.rook.io)

git clone https://github.com/rook/rook
cd rook/cluster/examples/kubernetes/ceph
git branch -a
git checkout remotes/origin/release-1.6 -f
kubectl apply -f common.yaml -f operator.yaml
kubectl apply -f crds.yaml
cp cluster.yaml cluster.yaml.bak12
vim cluster.yaml  ##edit cluster.yaml for sd[b-c]
kubectl apply -f cluster.yaml 
kubectl get pods -n rook-ceph  -w
```

issues  
[rook-ceph-disaster-recovery](https://github.com/rook/rook/blob/master/Documentation/ceph-disaster-recovery.md) 