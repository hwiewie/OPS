#!/bin/bash
#取得GeoIP.dat路徑
geoipdata=`grep GeoIP.dat /opt/APP/openresty/nginx/conf/nginx.conf | awk '{print $2}' | sed -r 's/;//g'`
#檢查是否有正常抓到GeoIP.dat的路徑
if [ -e $geoipdata ];then
    echo "geoip.dat存在，將繼續執行"
else
    echo "geoip.dat不存在！將離開程式！"
    exit
fi
#檢查/root/geoip.dat是否存在
if [ -e /root/geoip ];then
    echo "有找到新的geoip.dat，將繼續執行"
else
    echo "找不到新的geoip.dat！將離開程式！"
    exit
fi
#更新GeoIP.dat
cp /root/geoip.dat $geoipdata
#重載nginx設定
#nginx -s reload
systemctl reload nginx
