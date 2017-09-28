sed -i 's/set $MAM 1/set $MAM 0/g' /opt/APP/openresty/nginx/conf/vhost/*.conf
nginx -s reload
