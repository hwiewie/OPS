#!/bin/bash
function helps {
    echo "說明："
    echo "使用語法：sh domain_add.sh 指令 域名，共有2個參數要輸入"
    echo "參數一，指令，有下列三種可選用： add (新增)  del (刪除)  show (查詢)"
    echo "參數二，域名：就是要綁定或解除的域名"
    echo "如果在使用指令show時，可查詢所有域名"
}
function reloadnginx {
    #如果有動到conf檔就重啟
    if [ $? = 0 ] ;then
        #測試設定檔是否正確
        /opt/APP/openresty/nginx/sbin/nginx -t
        #重載nginx設定檔
        if [ $? = 0 ]; then
            echo "測試nginx設定檔成功，開始重載nginx設定檔"
            service nginx reload
            if [ $? = 0 ]; then
                echo "重新載入nginx設定檔成功"
            else
                echo "重載nginx設定檔失敗，請到RP上使用nginx -t查詢做確認"
                exit
            fi
        else
            echo "測試nginx設定檔失敗，請查看/opt/APP/openresty/nginx/conf/nginx.conf確認那邊出錯"
            exit
        fi
    fi
}
#確認是否有加密
netstat -plnt | grep 'nginx' | grep '443'
if [ $? = 0 ] ;then
    echo "有SSL"
    #列出所有vhost的conf檔
    nginxconf=/opt/APP/openresty/nginx/conf/vhost/*.conf
else
    echo "沒SSL"
    #列出所有vhost的conf檔
    nginxconf=/opt/APP/openresty/nginx/conf/vhost/*.conf
fi
#判斷是新增還是刪除
case "$1" in
"add")
    #判斷輸入參數個數
    if [ $# -ne "2" ];then
        echo "參數錯誤："
        helps
        exit
    fi
    #列出所有conf檔
    for filepathe in $nginxconf
    do
        echo "檢查是否有綁定過此域名"
        grep '^[ \s\t]*server_name[ \s\t]*[0-9A-Za-z]*\.[0-9A-Za-z]*' $filepathe | grep ' '$2'[ ;]' > /dev/null
        if [ $? = 0 ] ;then
            echo "$2此域名已綁定過了"
            continue
        else
            echo "開始新增$2到$filepathe"
            sed -i '/^[ \s\t]*server_name[ \s\t]*[0-9A-Za-z]*\.[0-9A-Za-z]*/s/;/ '$2';/' $filepathe
            if [ $? = 0 ] ;then
                echo "新增域名$2成功"
                reloadnginx
            else
                echo "新增域名$2失敗"
                exit
            fi
        fi
    done
    ;;
"del")
    #判斷輸入參數個數
    if [ $# -ne "2" ];then
        echo "參數錯誤："
        helps
        exit
    fi
    #列出所有conf檔
    for filepathe in $nginxconf
    do
        echo "檢查是否有綁定過此域名"
        grep '^[ \s\t]*server_name[ \s\t]*[0-9A-Za-z]*\.[0-9A-Za-z]*' $filepathe | grep ' '$2'[ ;]' > /dev/null
        if [ $? = 0 ] ;then
            echo "開始把$2從$filepathe刪除"
            sed -i '/^[ \s\t]*server_name[ \s\t]*[0-9A-Za-z]*\.[0-9A-Za-z]*/s/ '$2'//' $filepathe
            if [ $? = 0 ] ;then
                echo "刪除域名$2成功"
                reloadnginx
            else
                echo "刪除域名$2失敗"
                exit
            fi
        else
            echo "在$filepathe裡找不到$2這個域名"
            continue
        fi
    done
    ;;
"show")
    #抓取vhost config內綁定域名並解析出IP，把每個域名與IP中間用空白隔開，並每筆輸出成一行
    regex='^\w+\.+\w'
	if [[ -z "$2" ]] ;then
		domains=`grep '^[ \s\t]*server_name[ \s\t]*[0-9A-Za-z]*\.[0-9A-Za-z]*' $nginxconf | sed -r 's/(.*server_name\s*|;)//g' | uniq`
	else
	    grep '^[ \s\t]*server_name[ \s\t]*[0-9A-Za-z]*\.[0-9A-Za-z]*' $nginxconf | grep ' '$2'[ ;]'
		if [ $? = 0 ] ;then
		    domains=$2
		fi
	fi
    for domain in $domains; do
        if [[ $domain =~ $regex ]]; then
            echo -n $domain;
            ip=$(nslookup "$domain" | awk '/^Address: / { print $2 }')
            echo -n ' ';
            echo $ip;
        else
            echo $domain " is not match";
        fi
    done
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
