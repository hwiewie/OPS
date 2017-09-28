#sed -i 's/set $MAM 0/set $MAM 1/g' /opt/APP/openresty/nginx/conf/vhost/*.conf
sed -i 's/conf\/vhost/conf\/ma/g' /opt/APP/openresty/nginx/conf/nginx.conf

sed -i '/维护時間/d' /opt/Htdocs/ma/maintain.html
sed -i '/维护時間/d' /opt/Htdocs/ma/wap_maintain.html

sed -i '/在线客服/i\<p\>\<span\ class\=\"red\"\>维护時間 $1\-$2\<\/span\>\<\/p\>' /opt/Htdocs/ma/maintain.html
sed -i '/在线客服/i\<p\>\<span\ class\=\"red\"\>维护時間 $1\-$2\<\/span\>\<\/p\>' /opt/Htdocs/ma/wap_maintain.htm

nginx -s reload
