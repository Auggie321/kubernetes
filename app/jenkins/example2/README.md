# helm部署jenkins

环境介绍：

```
Ubuntu 20.04.4 LTS，4核8G，100G磁盘
组件：
1. docker
2. minikube
3. ingress-nginx
4. jenkins charts

比如最终是想，本机pc win网页访问私有域名：https://jenkins.example.com
即可登录Jenkins
```

部署

1.ubuntu部署docker过程略；

2.部署[minikube](https://minikube.sigs.k8s.io/docs/start/)

```
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
apt-get install -y conntrack

## 主要是想要用到宿主机的80，443端口，nodeport给ingress-nginx-controller来用；
minikube start --extra-config=apiserver.service-node-port-range=80-60000  --driver=none

vim ~/.bashrc
alias kubectl="minikube kubectl --"

source ~/.bashrc
kubectl get pods -A
```

3.部署ingress-nginx

```
虽然minikube官方可以直接部署ingress-nginx，为了方便后续的配置管理采用helm单独部署ingress-nginx

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm search repo ingress-nginx
helm pull ingress-nginx/ingress-nginx
tar -xf ingress-nginx-4.1.0.tgz
cd ingres-nginx
vim values.yaml

## 约502行，注释type: LoadBalancer，替换为NodePort；
#type: LoadBalancer
type: NodePort
   nodePorts:
      http: 80
      https: 443
      tcp:
        8080: 8080

helm install ingress-nginx -f values.yaml ./
```

4.部署jenkins

```
helm repo add jenkins https://charts.jenkins.io
helm repo update
helm search repo jenkins
helm pull jenkins/jenkins
tar -xf jenkins-3.12.0.tgz
cd jenkins

vim values.yaml
## 大约767行，修改storageclass持久化为本地默认的sc name; 
## minikube more的sc name为standard:
storageClass: standard

## 修改暴露jenkins的服务模式为ingress暴露；
ingress:
    enabled: true
    ingressClassName: nginx
    paths:
    - path: "/"
      pathType: Prefix
      backend:
        service:
          name: jenkins
          port:
            number: 8080
      # path: "/jenkins"
    apiVersion: "networking.k8s.io/v1"
    labels: {}
    annotations: {}
    # path: "/jenkins"
    # configures the hostname e.g. jenkins.example.com
    hostName: jenkins.test.com
    
    
 修改完成values.yaml，最后拉起jenkins服务，本地windows配置hosts私有jenkins域名与ip关系；
 
 helm install jenkins -f values.yaml ./
 
 等待几分钟登录网页； https://jenkins.test.com
 kubectl exec jenkins-0 -c jenkins -- cat /run/secrets/chart-admin-username
 kubectl exec jenkins-0 -c jenkins -- cat /run/secrets/chart-admin-passsword
```

6.更改jenkins的admin密码

```
helm jenkins的admin密码是放在secret jenkins内部的；
网页修改admin密码后，delete pod jenkins， admin的密码还是会被还原；
只能修改kubectl edit secret jenkins


secret 密码是经过base64加密，比如想把admin密码改成123456；
echo "123456"|base64  ##获取到加密后的密码：MTIzNDU2Cg==
更改了secret,然后在delete pods jenkins就会生效了；
```

