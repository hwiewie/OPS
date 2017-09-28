#!/bin/bash
echo "把nginx.conf內include vhost下所有conf改成include ma下所有conf"
echo "把nginx.conf內include vhost下所有conf那行的註解拿掉"
sed -i 's/\#include\ \/opt\/APP\/openresty\/nginx\/conf\/vhost\/\*.conf;/include\ \/opt\/APP\/openresty\/nginx\/conf\/vhost\/\*.conf;/g' /opt/APP/openresty/nginx/conf/nginx.conf
if [ $? = 0 ]; then
    echo "載入vhost目錄下conf成功"
else
    echo "載入vhost目錄下conf失敗"
fi
echo "把nginx.conf內include ma.conf那行的註解拿掉"
sed -i 's/include\ \/opt\/APP\/openresty\/nginx\/conf\/ma\/ma.conf;/\#include\ \/opt\/APP\/openresty\/nginx\/conf\/ma\/ma.conf;/g' /opt/APP/openresty/nginx/conf/nginx.conf
if [ $? = 0 ]; then
    echo "註解ma.conf成功"
else
    echo "註解ma.conf失敗"
fi
echo "重新載入nginx設定檔"
nginx -s reload
if [ $? = 0 ]; then
    echo "重新載入nginx設定檔成功"
    echo "完成！維護結束！請輸入該品牌app主網域網址進行測試！"
else
    echo "切換ma目錄失敗"
    echo "失敗！請確認/opt/APP/openresty/nginx/conf/ma/ma.conf內容是否正確！"
fi
