客户端 -> API Server  

user: username,uid  
group  
extra  

API  
Request path  
#/api/apps/v1/namespaces/default/deployment/myapp-deploy/  
Http request verb:  
#get, post, put, delete  
API requests verb:  
#get, list, create, update, patch,   
#watch, proxy, redirect, delete, deletecollection  
Resource:  
Subresource:  
Namespace:  
API group:  

#kubectl proxy --port=8111  
#curl http://localhost:8111/api/v1/namespaces  
#kubectl create -n  
#kubectl create serviceaccount mysa --dry-run  
#kubectl create serviceaccount mysa -o yaml --dry-run  
#kubectl get pods myapp-deploy-65df64765c-h2fvx -o yaml --export  
#kubectl get sa     #serviceaccount  
#kubectl create serviceaccount admin  
#kubectl describe sa admin  
#kubectl get secret  #会增加admin的token  
#kubectl config --help  
#kubectl config view  

simple example  
#cd /etc/kubernetes/pki/  
#(umask 077; openssl genrsa -out auggie.key 2048)  #创建私钥  
#openssl req -new -key auggie.key -out auggie.csr -subj "/CN=auggie"  #私钥创建私有证书  
#openssl x509 -req -in auggie.csr -CA ./ca.crt -CAkey ./ca.key -CAcreateserial -out auggie.crt -days 365  
#openssl x509 -in auggie.crt -text -noout  #证书查看  

#kubectl config set-credentials --help  
#kubectl config set-credentials auggie --client-certificate=./auggie.crt --client-key=./auggie.key --embed-crets=true  #User "auggie" set.  
#kubectl config view  #查询k8s集群当前配置信息  
#kubectl config set-context --help  
#kubectl config set-context auggie@kubernetes --cluster=kubernetes --user=auggie  

#kubectl config use-context auggie@kubernetes  #"Switch to context ...."  
#kubectl get pods  #切换到auggie用户下，检查当前用户拥有的pods资源  


#kubectl config set-cluster --help  
#kubectl config set-context kubernetes-admin@kubernetes  
#kubectl config set-cluster -h  
#kubectl config set-cluster  mycluster --kubeconfig=/tmp/test.config --server="https://192.168.2.199:6443" --certificate-authority=/etc/kubernetes/pki/ca.crt --embed-certs=true  
#kubectl config view --kubeconfig=/tmp/test.conf  

授权插件：Node， ABAC， RBAC， Webhook  
RBAC-based AC

role:
#operations
#objects

rolebinding
#user account OR service account
#role

clusterrole, clusterrolebinding

#kubectl create role --help  
#kubectl create role pods-reader --verb=get,list,watch --resource=pods --dry-run  
#kubectl create role pods-reader --verb=get,list,watch --resource=pods --dry-run -o yaml  #使用-o yaml查看当前配置的信息  
#
#kubectl create role pods-reader --verb=get,list,watch --resource=pods --dry-run -o yaml > ./role-demo.yaml  
#kubectl apply -f role-demo.yaml  
#kubectl get role  
#kubectl describe role pods-reader  

#kubectl create rolebinding auggie-read-pods --role=pods-reader --user=auggie --dry-run -o yaml > rolebinding-demo.yaml  
#kubectl explain rolebinding  
#kubectl explain rolebinding.roleRef  
#kubectl explain rolebinding.subjects  
#kubectl describe rolebinding auggie-read-pods  
#kubectl config use-context auggie@kubernetes  

#kubectl create clusterrole --help  
#kubectl create clusterrole cluster-reader --verb=get,list,watch --resource=pods -o yaml --dry-run  
#kubectl explain clusterrole.metadata  
#kubectl get clusterrole  
#kubectl create clusterrolebinding auggie-read-all-pods --clusterrole=cluster-reader --user=auggie --dry-run -o yaml > mainfests/account_rbac/clusterrolebinding-demo.yaml  
#kubectl get clusterrolebinding  
#kubectl describe clusterrolebindings auggie-read-all-pods  
#kubectl delete clusterrolebinding auggie-read-all-pods  

#kubectl create rolebinding auggie-read-pods --clusterrole=cluster-reader --user=auggie --dry-run -o yaml 
#kubectl describe rolebinding auggie-read-pods  

#kubectl get clusterrole  
#kubectl get clusterrole admin  
#kubectl get clusterrole admin -o yaml  
#kubectl create rolebinding default-ns-admin --clusterrole=admin --user=auggie  
#  
#kubectl get clusterrolebinding  
#
