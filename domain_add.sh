#!/bin/bash
function helps {
    echo "說明："
    echo "使用語法：sh domain_add.sh 指令 IP，共有2個參數要輸入"
    echo "參數一，指令，有下列三種可選用： add (新增)  del (刪除)  show (查詢)"
    echo "參數二，IP：就是要綁定或解除的IP"
    echo "如果在使用指令show時不帶IP，可查詢所有域名"
}
#判斷輸入參數個數
if [ $# -ne "2" ];then
    echo "參數錯誤："
    helps
    exit
fi
regex='^\w+\.+\w'
domains=`find /opt/APP/openresty/nginx/conf/vhost/ -type f -name "*.conf" -print0 | xargs -0 egrep '^(\s|\t)*server_name' | sed -r 's/(.*server_name\s*|;)//g' | uniq`
#確認是否有加密
netstat -plnt | grep 'nginx' | grep '443'
if [ $? = 0 ] ;then
    echo "有SSL"
    #列出所有vhost的conf檔
    nginxconf=/opt/APP/openresty/nginx/conf/vhost/*SSL*.conf
else
    echo "沒SSL"
    #列出所有vhost的conf檔
    nginxconf=/opt/APP/openresty/nginx/conf/vhost/*.conf
fi
#判斷是新增還是刪除
case "$1" in
"add")
    #列出所有conf檔
    for filepathe in $nginxconf
    do
        echo "檢查是否有綁定過此域名"
        grep "^(\s|\t)*server_name.*$2" $filepathe > /dev/null
        if [ $? = 0 ] ;then
            echo "$2此域名已綁定過了"
            continue
        else
            echo "開始新增$2到$filepathe"
            sed -i '^(\s|\t)*server_name/s/;/ '$2';/' $filepathe
            if [ $? = 0 ] ;then
                echo "新增域名$2成功"
            else
                echo "新增域名$2失敗"
                exit
            fi
        fi
    done
    ;;
"del")
    #列出所有conf檔
    for filepathe in $nginxconf
    do
        echo "檢查是否有綁定過此域名"
        grep "^(\s|\t)*server_name.*$2" $filepathe > /dev/null
        if [ $? = 0 ] ;then
            echo "開始把$2從$filepathe刪除"
            sed -i '^(\s|\t)*server_name/s/'$2'//' $filepathe
            if [ $? = 0 ] ;then
                echo "刪除域名$2成功"
            else
                echo "刪除域名$2失敗"
                exit
            fi
        fi
    done
    ;;
"show")
    ;;
*)
    echo "指令只有add、del、show這三種可以用"
    helps
    #if [[ $fe =~ *SSL* ]];then
        #echo " "
    #else
        #echo " "
    #fi
    exit
    ;;
esac
#如果有動到conf檔就重啟
if [ $? = 0 ] ;then
    #測試設定檔是否正確
    /opt/APP/openresty/nginx/sbin/nginx -t
    #重啟nginx服務
    if [ $? = 0 ]; then
        echo "測試nginx設定檔成功，開始重啟nginx"
        service nginx restart
        if [ $? = 0 ]; then
            echo "重新啟動nginx設定檔成功"
        else
            echo "重啟nginx失敗，請到RP上使用nginx -t查詢做確認"
            exit
        fi
    else
        echo "測試nginx設定檔失敗，請查看/opt/APP/openresty/nginx/conf/nginx.conf確認那邊出錯"
        exit
    fi
fi

