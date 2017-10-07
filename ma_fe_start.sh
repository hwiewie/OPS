#!/bin/bash
if [ ! -n "$1" ]; then
	stime='07:00'
else
    stime=$1
fi
if [ ! -n "$2" ]; then
    etime='08:00'
else
    etime=$2
fi
echo "把vhost所有conf改MAN為1"
#sed -i 's/conf\/vhost/conf\/ma/g' /opt/APP/openresty/nginx/conf/nginx.conf
sed -i 's/^\s*set $MAM 0/\    set $MAM 1/g' /opt/APP/openresty/nginx/conf/vhost/*.conf
if [ $? = 0 ]; then
    echo "切換MAM修改成功"
else
    echo "切換MAM修改失敗"
    exit
fi
echo "判斷ma.html路徑"
if [ ! -d "/opt/Htdocs/service" ]; then
    echo "舊版在/opt/Htdocs/ma"
    filepathe="/opt/Htdocs/ma/maintain.html"
    filepatha="/opt/Htdocs/ma/wap_maintain.html"
else
    echo "新版在/opt/Htdocs/service"
    filepathe="/opt/Htdocs/service/maintain.html"
    filepatha="/opt/Htdocs/service/wap_maintain.html"
fi
echo "判斷main.html與wap_maintain.html是否存在"
if [ -e $filepathe ];then
    echo "maintain.html存在，將繼續執行"
else
    echo "maintain.html不存在！請確認維謢網頁是否存在"
    #curl -s https://raw.githubusercontent.com/nickchangs/ma/master/maintain.html -o "$filepathe"
    exit
fi
if [ -e $filepatha ];then
    echo "wap_maintain.html存在，將繼續執行"
else
    echo "wap_maintain.html不存在！請確認網謢網頁是否存在"
    #curl -s https://raw.githubusercontent.com/nickchangs/ma/master/wap_maintain.html -o "$filepatha"
    exit
fi

echo "把上次維護時間從maintain.html網頁內移掉"
sed -i '/维护時間/d' $filepathe
if [ $? = 0 ]; then
    echo "從maintain.html移除上次維護時間成功"
else
    echo "從maintain.html移除上次維護時間失敗"
    exit
fi
echo "把上次維護時間從wap_maintain.html網頁內移掉"
sed -i '/维护時間/d' $filepatha
if [ $? = 0 ]; then
    echo "從wap_maintain.html移除上次維護時間成功"
else
    echo "從wap_maintain.html移除上次維護時間失敗"
    exit
fi

echo "維護開始時間：{$stime}，維護停止時間：{$etime}"
echo "開始寫入維護時間到maintain.html內"
sed -i '/在线客服/i\<p\>\<span\ class\=\"red\"\>维护時間\ '$stime'\-'$etime'\<\/span\>\<\/p\>' $filepathe
if [ $? = 0 ]; then
    echo "寫入維護時間到maintain.html內成功"
else
    echo "寫入維護時間到maintain.html內失敗"
    exit
fi
echo "開始寫入維護時間到wap_maintain.html內"
sed -i '/系统正在升级维护中/a\<p\>\<span\ class\=\"red\"\>维护時間\ '$stime'\-'$etime'\<\/span\>\<\/p\>' $filepatha
if [ $? = 0 ]; then
    echo "寫入維護時間到wap_maintain.html內成功"
else
    echo "寫入維護時間到wap_maintain.html內失敗"
    exit
fi

echo "重新載入nginx設定檔"
/opt/APP/openresty/nginx/sbin/nginx -s reload
if [ $? = 0 ]; then
    echo "重新載入nginx設定檔成功"
    echo "完成！請輸入該品牌前台主網域網址進行測試！"
else
    echo "切換ma目錄失敗"
    echo "失敗！請確認/opt/APP/openresty/nginx/conf/ma/ma.conf內容是否正確！"
    exit
fi
