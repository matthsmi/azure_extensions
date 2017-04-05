#!/bin/bash

PATH=/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin
export PATH

### BEGIN AWFUL FIXUPS
#
cp /etc/resolv.conf /etc/resolv.conf.bak
cat << EOF >> /etc/resolv.conf
nameserver 8.8.8.8
EOF

# I've seen the olcentgbl has a lot of 404 for files, and that screws the deployment
cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
sed -i 's/olcentgbl\.trafficmanager\.net/mirrors\.kernel\.org/g' /etc/yum.repos.d/CentOS-Base.repo
### END AWFUL FIXUPS

# yum -y update
yum -y install epel-release
yum -y install wget curl sssd ca-certificates yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum makecache fast
yum -y install docker-ce

cd /

if [ ! -d /opt ]; then
    mkdir /opt ; chmod 755 /opt
fi

if [ ! -d /config ]; then
    mkdir -p /config/certs /config/conf /config/conf.d ; chmod 755 /config /config/conf /config/certs /config/conf.d
fi

#FILES="loadtest_slash.tar.gz opt_nginx.tar.gz"
FILES="loadtest_slash.tar.gz"
for file in $FILES
do
    curl -k https://10.13.98.8/ztp/$file > /tmp/$file
    tar -zxvf /tmp/$file
    #rm -f /tmp/$file
done

curl -k https://10.13.98.8/ztp/nginx-sysctl.conf > /etc/sysctl.d/nginx.conf
curl -k https://10.13.98.8/ztp/docker-nginx.service > /etc/systemd/system/docker-nginx.service
curl -k https://10.13.98.8/ztp/nginx.conf > /config/nginx.conf
curl -k https://10.13.98.8/ztp/nginx-default.conf > /config/conf.d/default.conf

# Base Certs/Keys
curl -k https://10.13.98.8/ztp/admin_ethos-admin-net.chained.crt > /config/certs/admin_ethos-admin-net.chained.crt
curl -k https://10.13.98.8/ztp/admin_ethos-admin-net.key > /config/certs/admin_ethos-admin-net.key
curl -k https://10.13.98.8/ztp/web_wa1dev-ethos-adobe-net.chained.crt > /config/certs/web_wa1dev-ethos-adobe-net.chained.crt
curl -k https://10.13.98.8/ztp/web_wa1dev-ethos-adobe-net.key > /config/certs/web_wa1dev-ethos-adobe-net.key

setenforce 0
sysctl -p /etc/sysctl.d/nginx.conf

SERVICES="sssd sshd rsyslog docker docker-nginx.service"
for service in $SERVICES
do
    systemctl enable $service
    systemctl restart $service
done

mv /etc/resolv.conf.bak /etc/resolv.conf
mv /etc/yum.repos.d/CentOS-Base.repo.bak /etc/yum.repos.d/CentOS-Base.repo
exit 0
