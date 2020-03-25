service  
#工作模式： userspace <1.1 version, iptables < 1.10 version, ipvs 1.11+ version  

#kubectl explain svc  
#kubectl explain svc.spec  

#类型： ExternalName, ClusterIP, NodePort, and LoadBalancer  
#资源记录： SVC_NAME.NS_NAME.DOMAIN.LTD.  

ClusterIP, NodePort  
#NodePort:client -> NodeIP:NodePort -> ClusterIP:ServicePort -> PodIP:containerPort  