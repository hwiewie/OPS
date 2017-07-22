#!/bin/bash
domains=`find /opt/APP/openresty/nginx/conf/vhost/ -type f -name "*.conf" -print0 | xargs -0 egrep '^(\s|\t)*server_name' | sed -r 's/(.*server_name\s*|;)//g'` | sort -u
upstreams=`find /opt/APP/openresty/nginx/conf/vhost/ -type f -name "*.conf" -print0 | xargs -0 egrep '^(\s|\t)*server ([0-9]{1,3}\.)([0-9]{1,3}\.)([0-9]{1,3}\.)([0-9]{1,3}):60' | sed -r 's/(.*server\s*|;)//g'`
if [! -n "$upstreams"];then
   upstreams=`find /opt/APP/openresty/nginx/conf/vhost/ -type f -name "*.conf" -print0 | xargs -0 egrep '^(\s|\t)*server ([0-9]{1,3}\.)([0-9]{1,3}\.)([0-9]{1,3}\.)([0-9]{1,3}):([0-9]{2,5})' | sed -r 's/(.*server\s*|;)//g' | awk '{print $1}'`
fi
for fe in $upstreams
do
   #curl -A "Mozilla/5.0 (Linux; Android 4.4.4; Nexus 5 Build/KTU84P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/38.0.2125.114 Mobile Safari/537.36" -v $fe | awk 'BEGIN{FIELDWIDTHS="5 29"}{gsub(/^[ \t]+/, "", $2); gsub(/[ \t]+$/, "", $2); print $2}'
   exec 5<> /dev/tcp/`echo $fe | awk -F':' '{print $1}'`/`echo $fe | awk -F':' '{print $2}'`
   echo -e "GET / HTTP/1.1\r\nhost: http://$fe\r\nConnection: close\r\n\r\n" >&5
   cat <&5 | sed 's/ *<[^>]*> */ /g' #awk -v IGNORECASE=1 -v RS='</title' 'RT{gsub(/.*<title[^>]*>/,"");print;exit}' #sed -n '/^$/!{s/<[^>]*>/ /g;p;}'
done
