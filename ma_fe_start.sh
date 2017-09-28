#sed -i 's/set $MAM 0/set $MAM 1/g' /opt/APP/openresty/nginx/conf/vhost/*.conf
echo "把nginx.conf內include vhost下所有conf改成include ma下所有conf"
sed -i 's/conf\/vhost/conf\/ma/g' /opt/APP/openresty/nginx/conf/nginx.conf

echo "判斷main.html與wap_maintain.html是否存在"
filepathe="/opt/Htdocs/ma/maintain.html"
filepatha="/opt/Htdocs/ma/wap_maintain.html"
if [ ! -e $filepathe ];then
echo "maintain.html不存在！從github上下載…"
curl -s https://raw.githubusercontent.com/nickchangs/ma/master/maintain.html -o "/opt/Htdocs/ma/maintain.html"
fi
if [ ! -e $filepatha ];then
echo "wap_maintain.html不存在！從github上下載…"
curl -s https://raw.githubusercontent.com/nickchangs/ma/master/wap_maintain.html -o "/opt/Htdocs/ma/wap_maintain.html"
fi

echo "把上次維護時間從maintain.html網頁移掉"
sed -i '/维护時間/d' /opt/Htdocs/ma/maintain.html
echo "把上次維護時間從wap_maintain.html網頁移掉"
sed -i '/维护時間/d' /opt/Htdocs/ma/wap_maintain.html

echo "維護開始時間：{$1}，維護停止時間：{$2}"
echo "開始寫入維護時間到maintain.html內"
sed -i '/在线客服/i\<p\>\<span\ class\=\"red\"\>维护時間\ '$1'\-'$2'\<\/span\>\<\/p\>' /opt/Htdocs/ma/maintain.html
echo "開始寫入維護時間到wap_maintain.html內"
sed -i '/系统正在升级维护中/a\<p\>\<span\ class\=\"red\"\>维护時間\ '$1'\-'$2'\<\/span\>\<\/p\>' /opt/Htdocs/ma/wap_maintain.html

echo "重新載入nginx設定檔"
nginx -s reload
echo "完成！請輸入該品牌前台主網域網址進行測試！"
