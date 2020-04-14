
[官方jenkinsci/kubernetes-plugin](https://github.com/jenkinsci/kubernetes-plugin)
```
clone官方的代码，同时对service-account内secret权限和jenkins的文件进行了修改，供个人测试使用；
kubectl create namespace kubernetes-plugin
certificate.txt为制作证书的过程；
kubectl config set-context $(kubectl config current-context) --namespace=kubernetes-plugin
kubectl create service-account.yml
kubectl create -f jenkins.yml
建议：如果jenkins宿主机为国内节点，浏览器登录jenkins后，选择安装软件的部分，建议自定义取消所有勾选，然后下一步，
进入jenkins后，内部先安装Chinese插件；正确跟新jenkins国内源后，在选择插件安装会更快一点；
```