#!/bin/bash
#取得GeoIP.dat路徑
geoipdata=`grep GeoIP.dat /opt/APP/openresty/nginx/conf/nginx.conf | awk '{print $2}' | sed -r 's/;//g'`
#檢查是否有正常抓到GeoIP.dat的路徑
if [ -e $geoipdata ];then
    echo "geoip.dat存在，將進行備份"
    cp $geoipdata /opt/data/geoip/GeoIP.dat.bak
else
    echo "geoip.dat不存在！請確認GeoIP.dat是否存在，將離開程式！"
    exit
fi
#檢查/root/geoip.dat是否存在
if [ -e /root/geoip.dat ];then
    echo "有找到新的geoip.dat，將繼續執行"
else
    echo "找不到新的geoip.dat！將離開程式！"
    exit
fi
#更新GeoIP.dat
mv -f /root/geoip.dat $geoipdata
if [ $? = 0 ]; then
    echo "上傳geoip資料庫成功"
    #重載nginx設定
    /opt/APP/openresty/nginx/sbin/nginx -t
    if [ $? = 0 ]; then
        echo "測試nginx設定檔成功，開始重啟nginx"
    #nginx -s reload
    systemctl reload nginx
        if [ $? = 0 ]; then
            echo "重新啟動nginx設定檔成功"
        else
            echo "重啟nginx失敗，請使用nginx -t查詢正確認"
            exit
        fi
    else
        echo "測試nginx設定檔失敗，請查看/opt/APP/openresty/nginx/conf/nginx.conf確認那邊出錯"
    fi
fi
