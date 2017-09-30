#!/bin/bash
#判斷輸入參數
if [[ ! -n $1 ]]; then
   echo "you have not input an IP or a domain name!"
   exit
fi
#IP用的regex
regex="\b(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[1-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[1-9])\b"
#列出所有vhost的conf檔
nginxconf=/opt/APP/openresty/nginx/conf/vhost/*.conf
#判斷輸入參數是否為IP
if [[ $1 =~ $regex ]]; then
   echo "輸入是IP"
   #IP (前台GeoIP、後台iptables)
   #判斷是前台還是後台
   #fob=`cat /etc/salt/minion_id | awk 'BEGIN {FS="-"};{print $3}'`
   grep geoip_country /opt/APP/openresty/nginx/conf/nginx.conf > /dev/null
   if [ $? = 0 ] ;then
      echo "前台加GeoIP白名單"
      grep $1 /opt/APP/openresty/nginx/conf/nginx.conf > /dev/null
	  if [ $? = 1 ] ;then
	     echo "開始加入白名單"
	     lineno=`egrep -n '^(\s|\t)*default\s1;' /opt/APP/openresty/nginx/conf/nginx.conf | awk -F':' '{print $1}'`
		 echo "在$lineno行後面插入白名單記錄"
		 sed -i '$lineno a\          $1/32 0;' /opt/APP/openresty/nginx/conf/nginx.conf 
		 echo "重載nginx設定檔"
		 nginx -s reload
		 if [[ $? = 0 ]] ;then
		    echo "nginx設定檔重載成功"
		 fi
	  else
	     if [ $? = 0 ] ;then
	        echo "加過白名單了"
		 fi
	  fi
   else
      echo "後台加iptables"
      ttoday=`date +%Y%m%d`
	  echo "今天日期：$ttoday"
	  grep $1 /etc/sysconfig/iptables > /dev/null
	  if [ $? = 1 ] ;then
	     echo "開始將IP：$1 加入白名單"
         iptables -A INPUT -s $1/32 -p tcp -m multiport --dports 443,80 -m comment --comment "$ttoday Bot used Apply" -j ACCEPT
		 echo "開始重新載入iptables"
	     systemctl reload iptables
		 if [ $? = 0 ] ;then
		    echo "iptables重載成功"
		 else
		    echo "iptables重載失敗"
		 fi
	  else
	     echo "此IP：$1 已加入過白名單了"
	  fi
   fi
else
   echo "輸入是domain name"
   #域名(前台、支付)
   #列出所有conf檔
   for fe in $nginxconf
   do
      if [[ $fe =~ *SSL* ]];then
         echo " "
	  else
	     echo " "
      fi
   done
   
   
fi
