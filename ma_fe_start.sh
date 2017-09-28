sed -i 's/set $MAM 0/set $MAM 1/g' /opt/APP/openresty/nginx/conf/vhost/*.conf

curl -s https://raw.githubusercontent.com/nickchangs/ma/master/maintain.html -o "/opt/Htdocs/ma/maintain.html"
curl -s https://raw.githubusercontent.com/nickchangs/ma/master/wap_maintain.html -o "/opt/Htdocs/ma/wap_maintain.html"

nginx -s reload
