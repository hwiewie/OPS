#!/bin/bash
#取得目前DNS設定
dnsserver=`cat /etc/resolv.conf | grep nameserver | awk '{print $2}'`
if [ $dnsserver = "127.0.0.1" ]; then
   echo "有開DNS"
else
   echo "沒架DNS"
fi
dnslist=`cat /etc/resolv.dnsmasq.conf  | grep nameserver | awk '{print $2}'`
echo -n `date +%Y%m%d%H%M%S` >> test.log
echo -n ' ' >> test.log
echo `getent hosts cp929.com` >> test.log
for dnsa in $dnslist
do
dig cp929.com @$dnsa
done
