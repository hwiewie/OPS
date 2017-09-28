sed -i 's/set $MAM 1/set $MAM 0/g' /opt/APP/openresty/nginx/conf/vhost/*.conf
sed -i '/维护時間/d' /opt/Htdocs/ma/maintain.html
sed -i '/维护時間/d' /opt/Htdocs/ma/wap_maintain.html
nginx -s reload
