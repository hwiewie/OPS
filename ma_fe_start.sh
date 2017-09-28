#sed -i 's/set $MAM 0/set $MAM 1/g' /opt/APP/openresty/nginx/conf/vhost/*.conf
sed -i 's/conf\/vhost/conf\/ma/g' /opt/APP/openresty/nginx/conf/nginx.conf

filepathe="/opt/Htdocs/ma/maintain.html"
filepatha="/opt/Htdocs/ma/wap_maintain.html"
if [ -e $filepathe ];then
curl -s https://raw.githubusercontent.com/nickchangs/ma/master/maintain.html -o "/opt/Htdocs/ma/maintain.html"
fi
if [ -e $filepatha ];then
curl -s https://raw.githubusercontent.com/nickchangs/ma/master/wap_maintain.html -o "/opt/Htdocs/ma/wap_maintain.html"
fi

sed -i '/维护時間/d' /opt/Htdocs/ma/maintain.html
sed -i '/维护時間/d' /opt/Htdocs/ma/wap_maintain.html

sed -i '/在线客服/i\<p\>\<span\ class\=\"red\"\>维护時間\ '$1'\-'$2'\<\/span\>\<\/p\>' /opt/Htdocs/ma/maintain.html
sed -i '/系统正在升级维护中/a\<p\>\<span\ class\=\"red\"\>维护時間\ '$1'\-'$2'\<\/span\>\<\/p\>' /opt/Htdocs/ma/wap_maintain.html

nginx -s reload
