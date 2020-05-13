#### JMX Beans
git clone https://github.com/prometheus/jmx_exporter.git  
cd jmx_exporter  
mvn package  
cp jmx_exporter/jmx_prometheus_javaagent/target/jmx_prometheus_javaagent-0.12.1-SNAPSHOT.jar ./  
wget https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.12.0/jmx_prometheus_javaagent-0.12.0.jar  

#### Get catalina.sh and edit it  
docker run -d --name tomcattmp -p 8888:8080 tomcat  
docker cp tomcattmp:/usr/local/tomcat/bin/catalina.sh ./  
```
vim catalina.sh
##### Line 154  
# CLASSPATH=  
CLASSPATH=/usr/local/tomcat/bin  
##### Line 258  
#JAVA_OPTS="$JAVA_OPTS $JSSE_OPTS"  
JAVA_OPTS="-javaagent:/usr/local/tomcat/bin/jmx_prometheus_javaagent-0.12.0.jar=1234:/usr/local/tomcat/bin/  prometheus-jmx-config.yaml $JAVA_OPTS  $JSSE_OPTS"  
```

#### Dockerfile  
```
FROM tomcat
## Container tomcat run some xxx.jar

RUN mkdir /data
ADD jmx_prometheus_javaagent-0.12.1-SNAPSHOT.jar /data/jmx_prometheus_javaagent-0.12.1-SNAPSHOT.jar
ADD jmx_prometheus_javaagent-0.12.0.jar /data/jmx_prometheus_javaagent-0.12.0.jar
ADD prometheus-jmx-config.yaml /data/prometheus-jmx-config.yaml
CMD java -javaagent:/data/jmx_prometheus_javaagent-0.12.0.jar=1234:/data/prometheus-jmx-config.yaml -jar /usr/local/tomcat/start.jar
## java XXX -javaagent:/root/jmx_exporter/jmx_prometheus_javaagent-0.12.0.jar=1234:/root/jmx_exporter/config.yaml  -jar XXX.jar
```
```
FROM tomcat
## default tomcat

COPY jmx_prometheus_javaagent-0.12.0.jar /usr/local/tomcat/bin/
COPY prometheus-jmx-config.yaml /usr/local/tomcat/bin/
COPY catalina.sh /usr/local/tomcat/bin/
CMD ["catalina.sh", "run"]
```
#### Test tomcat docker image  
docker build -t tomcat:jmx1234 ./  
docker run -d --name tomcattmp -p 8099:8080 -p 1234:1234 tomcat:jmx1234  
curl xx.xx.xx.xx:1234  
curl xx.xx.xx.xx:1234/metrics  