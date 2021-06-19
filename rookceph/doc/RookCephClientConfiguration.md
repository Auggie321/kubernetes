Search ceph in vms with toolbox's ceph.conf & kering

One of kubernetest master operation:

```
root@centos1 ~/rook/ $ kubectl -n rook-ceph exec -it $(kubectl -n rook-ceph get pod -l "app=rook-ceph-tools" -o jsonpath='{.items[0].metadata.name}') cat /etc/ceph/ceph.conf > /etc/ceph/ceph.conf

root@centos1 ~/rook/$ kubectl -n rook-ceph exec -it $(kubectl -n rook-ceph get pod -l "app=rook-ceph-tools" -o jsonpath='{.items[0].metadata.name}') cat /etc/ceph/keyring > /etc/ceph/keyring

```

```
tee /etc/yum.repos.d/ceph.repo <<-'EOF'
[Ceph]
name=Ceph packages for $basearch
baseurl=http://mirrors.aliyun.com/ceph/rpm-nautilus/el7/$basearch
enabled=1
gpgcheck=0
type=rpm-md
gpgkey=https://mirrors.aliyun.com/ceph/keys/release.asc
priority=1

[Ceph-noarch]
name=Ceph noarch packages
baseurl=http://mirrors.aliyun.com/ceph/rpm-nautilus/el7/noarch
enabled=1
gpgcheck=0
type=rpm-md
gpgkey=https://mirrors.aliyun.com/ceph/keys/release.asc
priority=1

[ceph-source]
name=Ceph source packages
baseurl=http://mirrors.aliyun.com/ceph/rpm-nautilus/el7/SRPMS
enabled=1
gpgcheck=0
type=rpm-md
gpgkey=https://mirrors.aliyun.com/ceph/keys/release.asc
priority=1
EOF
```

```
yum -y install ceph-common ceph-fuse
```

```
root@centos1 ~/rook/ $ ceph status
  cluster:
    id:     00d02a67-316f-4e7b-9cbf-1d564f20a071
    health: HEALTH_OK
 
  services:
    mon: 3 daemons, quorum a,b,c (age 66m)
    mgr: a(active, since 65m)
    osd: 6 osds: 6 up (since 66m), 6 in (since 9h)
 
  data:
    pools:   1 pools, 1 pgs
    objects: 0 objects, 0 B
    usage:   33 MiB used, 300 GiB / 300 GiB avail
    pgs:     1 active+clean

```

