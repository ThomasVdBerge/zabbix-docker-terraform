FROM monitoringartist/zabbix-xxl:latest

RUN yum install -y python-boto

ADD externalscripts/* /usr/local/share/zabbix/externalscripts/
ADD startup.sh .

ENTRYPOINT /bin/bash ./startup.sh
