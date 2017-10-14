#!/bin/bash
#設定時間格式
ttoday=`date +%Y%m%d`
#設定後台iptables
filepathe="/etc/sysconfig/iptables"
if [ -e $filepathe ];then
    echo "iptables存在，將繼續執行"
else
    echo "iptables不存在！將離開程式！"
    exit
fi
#判斷輸入參數個數
case "$#" in
"1")
    echo "1"
	grep "^[- ].*$1" $filepathe > /dev/null
	if [ $? = 1 ] ;then
	    echo "開始將IP：$1 加入白名單"
        #看是否被註解
        grep "^#.*$1" $filepathe > /dev/null
		if [ $? = 0 ] ;then
            #移掉註解
            echo "移掉註解"
			sed -i 's/^#//g' $filepathe
        else
            #裡面沒這筆IP記錄，開始新增
            echo "使用iptables -A指令新增"
            iptables -A INPUT -s $1/32 -p tcp -m multiport --dports 443,80 -m comment -- comment "$ttoday Bot used Apply" -j ACCEPT
        fi	     
        #如果移掉註解或新增記錄成功，就重載iptables		
        if [ $? = 0 ] ;then
            echo "開始重新載入iptables"
            systemctl reload iptables
            if [ $? = 0 ] ;then
                echo "iptables重載成功"
            else
                echo "iptables重載失敗"
                exit
            fi
        else
            echo "加入白名單失敗"
            exit
        fi
    else
        echo "已加入過白名單了"
		exit
    fi
	;;
"2")
    echo "2"
	grep "^[- ].*$1" $filepathe > /dev/null
	if [ $? = 1 ] ;then
	    echo "開始將IP：$1 加入白名單"
        #看是否被註解
        grep "^#.*$1" $filepathe > /dev/null
		if [ $? = 0 ] ;then
            #刪除註解
            echo "移掉舊記錄"
			sed -i '/^#.*'$1'//g' $filepathe
        fi
        #裡面沒這筆IP記錄，開始新增
        echo "使用iptables -A指令新增"
        iptables -A INPUT -s $1/32 -p tcp -m multiport --dports 443,80 -m comment -- comment "$ttoday $2 used Apply" -j ACCEPT	     
        #如果移掉註解或新增記錄成功，就重載iptables		
		if [ $? = 0 ] ;then
            echo "開始重新載入iptables"
            systemctl reload iptables
            if [ $? = 0 ] ;then
                echo "iptables重載成功"
            else
                echo "iptables重載失敗"
                exit
            fi
        else
		    echo "加入白名單失敗"
			exit
		fi
    else
        echo "已加入過白名單了"
		exit
    fi
	;;
*)
    echo "Parameter input error"
	;;
esac
