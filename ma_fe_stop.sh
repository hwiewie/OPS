sed -i 's/conf\/ma/conf\/vhost/g' /opt/APP/openresty/nginx/conf/nginx.conf
sed -i '/维护時間/d' /opt/Htdocs/ma/maintain.html
sed -i '/维护時間/d' /opt/Htdocs/ma/wap_maintain.html
nginx -s reload
