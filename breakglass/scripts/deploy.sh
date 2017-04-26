#!/bin/bash

PATH=/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin
export PATH

yum -y install curl

if [ ! -d /home/centos/.ssh ]; then
    mkdir -p /home/centos/.ssh
fi

curl https://raw.githubusercontent.com/matthsmi/azure_extensions/master/breakglass/files/public_keys.txt > /home/centos/.ssh/authorized_keys
chown centos:centos /home/centos/.ssh/authorized_keys

exit 0
