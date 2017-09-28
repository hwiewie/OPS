sed -i 's/\#include \/opt\/APP\/openresty\/nginx\/conf\/vhost\/*.conf;/include \/opt\/APP\/openresty\/nginx\/conf\/vhost\/*.conf;/g' /opt/APP/openresty/nginx/conf/nginx.conf
sed -i 's/include \/opt\/APP\/openresty\/nginx\/conf\/ma\/ma.conf;/\#include \/opt\/APP\/openresty\/nginx\/conf\/ma\/ma.conf;/g' /opt/APP/openresty/nginx/conf/nginx.conf

nginx -s reload
