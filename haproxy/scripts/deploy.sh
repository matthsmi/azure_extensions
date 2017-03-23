#!/bin/bash

PATH=/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin
export PATH

# yum -y update
yum -y install epel-release
yum -y install haproxy wget curl sssd ca-certificates
systemctl enable haproxy

curl -k https://10.13.98.8/ztp/loadtest_slash.tar.gz > /tmp/loadtest_slash.tar.gz

cd /
tar -zxvf /tmp/loadtest_slash.tar.gz

SERVICES="sssd sshd rsyslog haproxy"
for service in $SERVICES
do
    systemctl restart $service
done

setenforce 0

exit 0
