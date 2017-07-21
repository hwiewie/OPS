#!/bin/bash
domains=`find /opt/APP/openresty/nginx/conf/vhost/ -type f -name "*.conf" -print0 | xargs -0 egrep '^(\s|\t)*server_name' | sed -r 's/(.*server_name\s*|;)//g'`
upstreams=`find /opt/APP/openresty/nginx/conf/vhost/ -type f -name "*.conf" -print0 | xargs -0 egrep '^(\s|\t)*server ([0-9]{1,3}\.)([0-9]{1,3}\.)([0-9]{1,3}\.)([0-9]{1,3}):60' | sed -r 's/(.*server\s*|;)//g'`
for fe in $upstreams
do
   curl -A "Mozilla/5.0 (Linux; Android 4.4.4; Nexus 5 Build/KTU84P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/38.0.2125.114 Mobile Safari/537.36" -v $fe
done
