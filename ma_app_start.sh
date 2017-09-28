#!/bin/bash
ttoday=`date +%m-%d`
echo "把nginx.conf內include vhost下所有conf改成include ma下所有conf"
sed -i 's/include \/opt\/APP\/openresty\/nginx\/conf\/vhost\/\*.conf;/\#include \/opt\/APP\/openresty\/nginx\/conf\/vhost\/\*.conf;/g' /opt/APP/openresty/nginx/conf/nginx.conf
if [ $? = 0 ]; then
    echo "註解vhost成功"
else
    echo "註解vhost失敗"
fi
sed -i 's/\#include \/opt\/APP\/openresty\/nginx\/conf\/ma\/ma.conf;/include \/opt\/APP\/openresty\/nginx\/conf\/ma\/ma.conf;/g' /opt/APP/openresty/nginx/conf/nginx.conf
if [ $? = 0 ]; then
    echo "載入ma.conf成功"
else
    echo "載入ma.conf失敗"
fi
echo "修改ma.conf，設定開始維護與停止維護時間"
echo "維護開始時間：{$1}，維護停止時間：{$2}"
sed -i 's/StartTime\":\"[0-9]\{2\}-[0-9]\{2\}\ [0-9]\{2\}:[0-9]\{2\}/StartTime\":\"'$ttoday'\ '$1'/' /opt/APP/openresty/nginx/conf/ma/ma.conf
sed -i 's/EndTime\":\"[0-9]\{2\}-[0-9]\{2\}\ [0-9]\{2\}:[0-9]\{2\}/EndTime\":\"'$ttoday'\ '$2'/' /opt/APP/openresty/nginx/conf/ma/ma.conf
echo "修改結果如下："
grep '[0-9]\{2\}-[0-9]\{2\}\ [0-9]\{2\}:[0-9]\{2\}' /opt/APP/openresty/nginx/conf/ma/ma.conf
echo "重新載入nginx設定檔"
nginx -s reload
if [ $? = 0 ]; then
    echo "重新載入nginx設定檔成功"
    echo "完成！請輸入該品牌app主網域網址進行測試！"
else
    echo "切換ma目錄失敗"
    echo "失敗！請確認/opt/APP/openresty/nginx/conf/ma/ma.conf內容是否正確！"
fi
