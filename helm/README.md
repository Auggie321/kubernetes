Helm:  
核心术语:  
chart:一个helm程序包  
Repository:Charts仓库，https/http服务器  
Release:特定的Chart部署于目标集群上的一个实例  
Chart -> Config -> Release  

程序架构：  
helm：客户端，管理本地的Chart仓库，管理Chart,与Tiller服务器交互，发送Chart,实例安装、查询、卸载等操作    
Tiller:服务器，接收helm发来的Charts与Config，合并生成release  

#wget https://get.helm.sh/helm-v2.14.1-linux-amd64.tar.gz  
#tar -xf helm-v2.14.1-linux-amd64.tar.gz  
#cd linux-amd64/  
#mv helm /usr/bin/  
#helm --help  
#kubectl apply -f tiller-rbac.yaml  ##重要  
#kubectl get sa -n kube-system  
#helm init --service-account tiller  

GFW caused helm repo init failed.  
https://github.com/jenkins-x/jx/issues/1171  
#helm repo remove stable  
#helm init --upgrade -i \registry.cn-hangzhou.aliyuncs.com/google_containers/tiller:v2.14.1 \--stable-repo-url \https://kubernetes.oss-cn-hangzhou.aliyuncs.com/charts   
#helm repo add stable https://kubernetes.oss-cn-hangzhou.aliyuncs.com/charts  
#helm version   #部署完查看版本    
#helm repo update  #跟新远程仓库  
#helm repo list  
#helm search  
官方可用的Chart列表：  
https://hub.kubeapps.com/  

#helm search jenkins  
#helm inspect jenkins  
#helm inspect stable/jenkins  
#helm search memcached  
#helm inspect stable/memcached  

#安装  
#helm install --name mem1 stable/memcached   #卸载helm delete mem1  
#出现问题：  
<!-- helm install --name mem1 stable/memcached  
Error: release mem1 failed: namespaces "default" is forbidden: User "system:serviceaccount:kube-system:default" cannot get resource "namespaces" in API group "" in the namespace "default" -->  
解决： https://github.com/fnproject/fn-helm/issues/21  
#kubectl get sa -n kube-system  #检查tiller是否已经创建  
#kubectl get clusterrolebinding #检查是否创建  
#kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'  

#helm常用命令  
#release管理：  
##install  
##delete  
##upgrade/rollback  
##list  
##history  #release的历史  
##status #获取release状态信息  

#chart管理  
##create  
##fetch  
##get  
##inspect  
##package  
##verify  

[root~/.helm] $tree  
.  
├── cache  
│   └── archive  
│       ├── jenkins-0.13.5.tgz  
│       ├── memcached-2.0.1.tgz  
│       └── redis-1.1.15.tgz  
├── plugins  
├── repository  
│   ├── cache  
│   │   ├── local-index.yaml -> /root/.helm/repository/local/index.yaml  
│   │   └── stable-index.yaml  
│   ├── local  
│   │   └── index.yaml  
│   └── repositories.yaml  
└── starters  
#cd root && cd .helm  
#tar -xf redisxxxxx  
#helm delete redis1  
#helm install --name redis1 -f values.yaml stable/redis  
#
#helm lint ../myapp  #语法检查  
#helm package myapp/  
#