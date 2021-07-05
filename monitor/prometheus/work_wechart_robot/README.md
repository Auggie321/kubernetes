```
创建企业微信的webhook url.
git clone https://github.com/daozzg/work_wechat_robot.git
cd work_wechat_robot
docker build -t daozzg/work-wechat-robot:latest ./
kubectl apply -f deployment.yaml
kubectl delete secret alertmanager-main -n monitoring
kubectl create secret generic alertmanager-main --from-file=alertmanager.yaml -n monitoring
##kubectl create secret generic alertmanager-main --from-file=alertmanager.yaml --from-file=yhwebhook.tmpl -n monitoring
kubectl logs -f --tail=20 -n monitoring alertmanager-main-0
```