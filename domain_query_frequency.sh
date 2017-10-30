#!/bin/bash
#取得目前DNS設定
dnsserver = `cat /etc/resolv.conf | grep nameserver | awk '{print $2}'`
if [ $dnsserver = "127.0.0.1" ]; then
   echo "有開DNS"
else
   echo "沒架DNS"
fi
cat /etc/resolv.dnsmasq.conf  | grep nameserver | awk '{print $2}'
echo -n `date +%Y%m%d%H%M%S` >> test.log
echo `getent host $1` >> test.log
