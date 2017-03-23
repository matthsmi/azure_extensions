#!/bin/bash

PATH=/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin
export PATH

# yum -y update
yum -y install epel-release
yum -y install wget curl sssd ca-certificates

cd /

if [ ! -d /opt ]; then
    mkdir /opt ; chmod 755 /opt
fi

FILES="loadtest_slash.tar.gz opt_haproxy.tar.gz"
for file in $FILES
do
    curl -k https://10.13.98.8/ztp/$file > /tmp/$file
    tar -zxvf /tmp/$file
    rm -f /tmp/$file
done

curl -k https://10.13.98.8/ztp/haproxy.cfg /opt/haproxy/etc
curl -k https://10.13.98.8/ztp/haproxy-sysctl.conf /etc/sysctl.d/haproxy.conf

cp /opt/haproxy/systemd/haproxy.service /etc/systemd/system/haproxy.service

SERVICES="sssd sshd rsyslog haproxy"
for service in $SERVICES
do
    systemctl enable $service
    systemctl restart $service
done

setenforce 0
sysctl -p /etc/sysctl.d/haproxy.conf

exit 0
