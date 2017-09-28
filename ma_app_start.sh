sed -i 's/include \/opt\/APP\/openresty\/nginx\/conf\/vhost\/*.conf;/#include \/opt\/APP\/openresty\/nginx\/conf\/vhost\/*.conf;/g' /opt/APP/openresty/nginx/conf/nginx.conf
sed -i 's/#include \/opt\/APP\/openresty\/nginx\/conf\/ma\/ma.conf;/include \/opt\/APP\/openresty\/nginx\/conf\/ma\/ma.conf;/g' /opt/APP/openresty/nginx/conf/nginx.conf

curl -s https://raw.githubusercontent.com/nickchangs/ma/master/ma-APP.conf -o "/opt/APP/openresty/nginx/conf/ma/ma.conf"
nginx -s reload
