#!/bin/bash
#抓取vhost config內綁定域名並解析出IP，把每個域名與IP中間用空白隔開，並每筆輸出成一行
domains=`find /opt/APP/openresty/nginx/conf/vhost/ -type f -name "*.conf" -print0 | xargs -0 egrep '^(\s|\t)*server_name' | sed -r 's/(.*server_name\s*|;)//g'`
for domain in $domains; do
    echo -n $domain;
    ip=$(nslookup "$domain" | awk '/^Address: / { print $2 }')
    echo -n ' ';
    echo $ip;
done
