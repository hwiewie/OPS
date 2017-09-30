#!/bin/bash
#判斷輸入參數
if [ ! -n $1 ]; then
   echo "you have not input an IP or a domain name!"
   exit
fi
#IP用的regex
regex='\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b'
#列出所有vhost的conf檔
nginxconf=/opt/APP/openresty/nginx/conf/vhost/*.conf
#判斷輸入參數是否為IP
if [[ $1 =~ $regex ]]; then
   #IP (前台GeoIP、後台iptables)
   #判斷是前台還是後台
   fob=`cat /etc/salt/minion_id | awk 'BEGIN {FS="-"};{print $3}'`
   if [ $fob = 'fe' ] ;then
      haveip=`grep $1 /opt/APP/openresty/nginx/conf/nginx.conf`
	  if [ ! -n $haveip ] ;then
	     
	  fi
   else
      ttoday=`date +%Y%m%d`
	  haveip=`grep $1 /etc/sysconfig/iptables`
	  if [ ! -n $haveip ] ;then
         iptables -A INPUT -s $1/32 -p tcp -m multiport --dports 443,80 -m comment --comment '$ttoday Bot used Apply' -j ACCEPT
	     systemctl reload iptables
	  fi
   fi
else
   #域名(前台、支付)
   #列出所有conf檔
   for fe in $nginxconf
   do
      if [[ $fe =~ *SSL* ]];then
         
	  else
	     
      fi
   done
   
   
fi
#找出 server_name 在那一行
doaminline = `grep -n '[[:blank:]]*server_name [[:alnum:]]' /opt/APP/openresty/nginx/conf/vhost/001-500vip-F-01.conf | awk -F':' '{print $1}'`
