FROM tomcat
## default tomcat

COPY jmx_prometheus_javaagent-0.12.0.jar /usr/local/tomcat/bin/
COPY prometheus-jmx-config.yaml /usr/local/tomcat/bin/
COPY catalina.sh /usr/local/tomcat/bin/
CMD ["catalina.sh", "run"]
