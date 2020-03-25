> * glusterfs，持久化存储的demo    
[jimmysong 5.6.1-GlusterFS](https://jimmysong.io/kubernetes-handbook/practice/using-glusterfs-for-persistent-storage.html)  
[CSDN shuai_wow k8s配置glusterfs](https://blog.csdn.net/u013431916/article/details/79729391)  

```
glusterfs优化的部分cache-size的值要注意和机器的内存的大小关系，大于内存可能导致pod初始化失败
tail /var/log/glusterfs/glusterd.log
```

#kubectl explain pods.spec.volumes  
#kubectl explain pods.spec.volumes.emptyDir  
#kubectl explain pods.spec.containers  
#kubectl explain pods.spec.containers.volumeMounts  

#kubectl exec -it pod-demo -c busybox -- /bin/sh  
#kubectl explain pods.spec.volumes.hostPath.type  
#kubectl explain pvc  
#kubectl explain pv.spec.nfs  

#kubectl create configmap --help  待续  
#kubectl get cm  
#kubectl edit cm nginx-config  
#kubectl describe cm nginx-config  待续  

#kubectl create secret --help  

配置容器化应用的方式  
#1.自定义命令行参数：args: []  

#2.把配置文件直接配进镜像;  

#3.环境变量  
#--[1] Cloud Native的应用程序一般可直接通过环境变量加载配置；  
#--[2] 通过entrypoint脚本来预处理变量为配置文件中的配置信息；  

#4.存储卷  
