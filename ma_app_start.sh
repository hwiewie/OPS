#!/bin/bash
ttoday=`date +%m-%d`
echo "把nginx.conf內include vhost下所有conf改成include ma下所有conf"
sed -i 's/include \/opt\/APP\/openresty\/nginx\/conf\/vhost\/*.conf;/\#include \/opt\/APP\/openresty\/nginx\/conf\/vhost\/*.conf;/g' /opt/APP/openresty/nginx/conf/nginx.conf
if [ $? = 0 ]; then
    echo "切換ma目錄成功"
else
    echo "切換ma目錄失敗"
fi
echo "修改ma.conf，設定開始維護與停止維護時間"
echo "維護開始時間：{$1}，維護停止時間：{$2}"

echo "重新載入nginx設定檔"
nginx -s reload
if [ $? = 0 ]; then
    echo "重新載入nginx設定檔成功"
    echo "完成！請輸入該品牌app主網域網址進行測試！"
else
    echo "切換ma目錄失敗"
    echo "失敗！請確認/opt/APP/openresty/nginx/conf/ma/ma.conf內容是否正確！"
fi
