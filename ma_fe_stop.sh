echo "設定nginx.conf，把載入conf目錄從vhost切換成ma"
sed -i 's/conf\/ma/conf\/vhost/g' /opt/APP/openresty/nginx/conf/nginx.conf
if [ $? = 0 ]; then
    echo "切換ma目錄成功"
else
    echo "切換ma目錄失敗"
fi
echo "把維護時間從maintain.html內清除"
sed -i '/维护時間/d' /opt/Htdocs/ma/maintain.html
if [ $? = 0 ]; then
    echo "maintain.html清除維護時間成功"
else
    echo "maintain.html清除維護時間失敗"
fi
echo "把維護時間從wap_maintain.html內清除"
sed -i '/维护時間/d' /opt/Htdocs/ma/wap_maintain.html
if [ $? = 0 ]; then
    echo "wap_maintain.html清除維護時間成功"
else
    echo "wap_maintain.html清除維護時間失敗"
fi
nginx -s reload
if [ $? = 0 ]; then
echo "nginx重載設定檔成功"
else
echo "nginx重載設定檔失敗"
fi
