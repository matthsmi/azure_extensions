#!/bin/bash

PATH=/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin
export PATH

# yum -y update
yum -y install epel-release
yum -y install wget curl sssd ca-certificates yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum makecache fast
yum -y install docker-ce

cd /

if [ ! -d /opt ]; then
    mkdir /opt ; chmod 755 /opt
    mkdir /config ; chmod 755 /config
fi

#FILES="loadtest_slash.tar.gz opt_haproxy.tar.gz"
FILES="loadtest_slash.tar.gz"
for file in $FILES
do
    curl -k https://10.13.98.8/ztp/$file > /tmp/$file
    tar -zxvf /tmp/$file
    rm -f /tmp/$file
done

#curl -k https://10.13.98.8/ztp/haproxy.cfg > /opt/haproxy/etc
#curl -k https://10.13.98.8/ztp/haproxy-sysctl.conf > /etc/sysctl.d/haproxy.conf
#cp /opt/haproxy/systemd/haproxy.service /etc/systemd/system/haproxy.service
curl -k https://10.13.98.8/ztp/docker-haproxy.service > /etc/sytemd/system/docker-haproxy.service
curl -k https://10.13.98.8/ztp/haproxy.cfg > /config

setenforce 0
sysctl -p /etc/sysctl.d/haproxy.conf

#SERVICES="sssd sshd rsyslog haproxy"

#SERVICES="sssd sshd rsyslog docker docker-haproxy.service"
#for service in $SERVICES
#do
#    systemctl enable $service
#    systemctl restart $service
#done

exit 0
