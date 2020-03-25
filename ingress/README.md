#kubectl explain ingress  
#kubectl explain ingress.spec.rules  
#kubectl explain ingress.spec.rules.httpls  

#kubectl get pods -n ingress-nginx   
#kubectl describe -n ingress-nginx pod nginx-ingress-controller-797b884cbc-wzfcw   
#kubectl describe pods -n ingress-nginx   nginx-ingress-controller-797b884cbc-wzfcw    

#kubectl describe ingress ingress-myapp  
#kubectl exec -n ingress-nginx -it nginx-ingress-controller-xxxx  -- /bin/sh  

#wget  https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/baremetal/service-nodeport.yaml  
#auggie.demo.com:30080  
#auggie.tomcat.com:30080  

ingrss-nginx设置证书使用https访问  
证书制作  
#openssl genrsa -out tls.key 2048   
#openssl req -new -x509 -key tls.key -out tls.crt -subj /C=CN/ST=Beijing/L=Beijing/O=Devops/CN=tomcat.demo.com  
#cp ingress-tomcat.yaml ingress-tomcat-tls.yaml  
#kubectl describe ingress ingress-tomcat-tls  
#https://tomcat.demo.com:30443/  