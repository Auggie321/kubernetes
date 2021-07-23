| node name(example) | add disk for rook ceph | comment   |
| :----------------: | :--------------------: | --------- |
|   192.168.1.118    |        sdb,sdc         | k8s node1 |
|   192.168.1.119    |        sdb,sbc         | k8s node2 |
|   192.168.1.120    |        sdb,sbc         | k8s node3 |



Quickstart
######   ceph/ceph:v16.2.4
######   origin/release-1.6
```
ans 'modprobe rbd'
ans 'lsmod | grep rbd'
kubectl label nodes {192.168.1.118,192.168.1.119,192.168.1.120} ceph-osd=enabled  
kubectl label nodes {192.168.1.118,192.168.1.119,192.168.1.120} ceph-mon=enabled  
kubectl label nodes 192.168.1.118 ceph-mgr=enabled 
## rook as for now only support one mgr node      
```
[Issues: Failed to list *v1beta1.Cluster, why needs checkout](https://github.com/rook/rook/issues/2338)   
```
git clone https://github.com/rook/rook  
cd rook/cluster/examples/kubernetes/ceph  
git branch -a 
git checkout remotes/origin/release-1.6 -f   
kubectl apply -f crds.yaml -f common.yaml -f operator.yaml  
cp cluster.yaml cluster.yaml.bak12  
vim cluster.yaml  
```

See: [cluster.yaml example](https://github.com/Auggie321/kubernetes/blob/master/rookceph/example/cluster.yaml)   

``` 
root@centos1 ~/rook/cluster/examples/kubernetes/ceph ((detached from origin/release-1.6)) $ pwd
/root/rook/cluster/examples/kubernetes/ceph
kubectl apply -f cluster.yaml   
kubectl get pods -n rook-ceph  -w    
```

#### Deploy toolbox
```
root@centos1 ~/rook/cluster/examples/kubernetes/ceph ((detached from origin/release-1.6)) $ pwd
/root/rook/cluster/examples/kubernetes/ceph
kubectl apply -f toolbox.yaml

# into container toolbox
kubectl -n rook-ceph exec -it $(kubectl -n rook-ceph get pod -l "app=rook-ceph-tools" -o jsonpath='{.items[0].metadata.name}') bash

[root@rook-ceph-tools-fc5f9586c-z7csk /]# ceph -s
  cluster:
    id:     00d02a67-316f-4e7b-9cbf-1d564f20a071
    health: HEALTH_WARN
            mons are allowing insecure global_id reclaim
  services:
    ***
    pgs:     1 active+clean

[root@rook-ceph-tools-fc5f9586c-z7csk /]# ceph osd tree
ID  CLASS  WEIGHT   TYPE NAME               STATUS  REWEIGHT  PRI-AFF
-1         0.29279  root default                                     
-3         0.09760      host 192-168-1-118                           
 ***
-5         0.09760      host 192-168-1-120                           

## 实际Kubernetes rook中，不建议直接操作底层Ceph，以防止上层Kubernetes而言数据不一致
```
See: [Solved: mons are allowing insecure global_id reclaim ](https://github.com/rook/rook/issues/7746)  
See: [Execute ceph commands in vms with toolbox's ceph.conf & kering ](https://github.com/Auggie321/kubernetes/blob/master/rookceph/doc/RookCephClientConfiguration.md)   


Ceph Rbd Storage
```
root@centos1 ~/rook/cluster/examples/kubernetes/ceph ((detached from origin/release-1.6)) $ pwd
/root/rook/cluster/examples/kubernetes/ceph

kubectl apply -f csi/rbd/storageclass.yaml
kubectl get sc

##test pvc with storageclass
kubectl apply -f csi/rbd/pvc.yaml
kubectl get pvc;kubectl get pv
```

Ceph Object Storage
```
root@centos1 ~/rook/cluster/examples/kubernetes/ceph ((detached from origin/release-1.6)) $ pwd
/root/rook/cluster/examples/kubernetes/ceph
kubectl apply -f object.yaml
kubectl -n rook-ceph get pod -l app=rook-ceph-rgw
NAME                                       READY   STATUS    RESTARTS   AGE
rook-ceph-rgw-my-store-a-bc559fd65-6qs52   1/1     Running   0          34s

kubectl apply -f storageclass-bucket-delete.yaml
kubectl get sc

## create bucket
kubectl apply -f object-bucket-claim-delete.yaml 
kubectl -n default get cm ceph-delete-bucket -o yaml | grep BUCKET_HOST | awk '{print $2}'
rook-ceph-rgw-my-store.rook-ceph

$ kubectl -n rook-ceph get svc rook-ceph-rgw-my-store
NAME                     TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
rook-ceph-rgw-my-store   ClusterIP   10.68.157.79   <none>        80/TCP    18m

export AWS_HOST=$(kubectl -n default get cm ceph-delete-bucket -o yaml | grep BUCKET_HOST | awk '{print $2}')
export AWS_ACCESS_KEY_ID=$(kubectl -n default get secret ceph-delete-bucket -o yaml | grep AWS_ACCESS_KEY_ID | awk '{print $2}' | base64 --decode)
export AWS_SECRET_ACCESS_KEY=$(kubectl -n default get secret ceph-delete-bucket -o yaml | grep AWS_SECRET_ACCESS_KEY | awk '{print $2}' | base64 --decode)
export AWS_ENDPOINT='10.68.157.79'

## test bucket 
radosgw-admin bucket list

## centos7 install s3 client
yum --assumeyes install s3cmd

## create test file
echo "Hello Rook" > /tmp/rookObj

## test upload to bucket
s3cmd put /tmp/rookObj --no-ssl --host=${AWS_HOST} --host-bucket= s3://ceph-bkt-377bf96f-aea8-4838-82bc-2cb2c16cccfb/test.txt					#测试上传至bucket
提示：更多rook 对象存储使用，如创建用户等参考：https://rook.io/docs/rook/v1.1/ceph-object.html。
```
See: [rook bucket more info](https://rook.io/docs/rook/v1.6/ceph-object.html)  


Cephfs
```
# default rook ceph not install cephfilesystem, install template filesystem.yaml to create;
root@centos1 ~/rook/* $ pwd
/root/rook/cluster/examples/kubernetes/ceph
kubectl apply -f filesystem.yaml 

kubectl -n rook-ceph get pod -l app=rook-ceph-mds
NAME                                    READY   STATUS    RESTARTS   AGE
rook-ceph-mds-myfs-a-767d9969bc-vpj8k   1/1     Running   0          3m5s
rook-ceph-mds-myfs-b-7cb6645fb5-7q7b4   1/1     Running   0          3m4s

kubectl get cephfilesystems.ceph.rook.io -n rook-ceph
NAME   ACTIVEMDS   AGE     PHASE
myfs   1           4m29s   Ready

kubectl apply -f csi/cephfs/storageclass.yaml

## test cephfs pvc
kubectl apply -f csi/cephfs/pvc.yaml 
```
  
  
  
  
  
Tutorials   
[rook-ceph-disaster-recovery](https://github.com/rook/rook/blob/master/Documentation/ceph-disaster-recovery.md)  


[clear-rook-ceph](https://github.com/rook/rook/blob/master/Documentation/ceph-teardown.md)  
```

## check the rook resources whether delete all, use as following command checking:

kubectl api-resources --verbs=list --namespaced -o name \
| xargs -n 1 kubectl get --show-kind --ignore-not-found -n rook-ceph


kubectl delete -n rook-ceph cephblockpool replicapool 
kubectl delete cephfilesystem.ceph.rook.io -n rook-ceph  myfs

https://github.com/rook/rook/issues/6002
if del stucking in command {replicapool,myfs}, use bellowing command:
kubectl -n rook-ceph patch cephblockpool replicapool --type merge -p '{"metadata":{"finalizers": [null]}}'
kubectl -n rook-ceph patch cephfilesystem myfs --type merge -p '{"metadata":{"finalizers": [null]}}'

```

[rook-ceph-osd-management](https://github.com/rook/rook/blob/master/Documentation/ceph-osd-mgmt.md#remove-an-osd)  