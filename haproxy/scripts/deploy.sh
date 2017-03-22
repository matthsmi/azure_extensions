#!/bin/bash

# yum -y update
yum -y install epel-release
yum -y install haproxy wget curl sssd ca-certificates
systemctl enable haproxy

curl -k https://10.13.98.8/ztp/loadtest_slash.tar.gz > /tmp/loadtest_slash.tar.gz

cd /
tar -zxvf /tmp/loadtest_slash.tar.gz

systemctl restart sssd
systemctl restart sshd
systemctl start haproxy

exit 0
