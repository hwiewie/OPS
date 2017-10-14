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
if [ $# = 0 ];then
    echo "參數錯誤："
    exit
fi
#判斷是新增還是刪除
case "$1" in
"add")
    #判斷輸入參數個數
    case "$#" in
    "2")
	    echo "只輸入IP"
	    grep "^[- ].*$2" $filepathe > /dev/null
	    if [ $? = 1 ] ;then
	        echo "開始將IP：$2 加入白名單"
            #看是否被註解
            grep "^#.*$2" $filepathe > /dev/null
		    if [ $? = 0 ] ;then
                #移掉註解
                echo "移掉註解"
			    sed -i 's/^#//g' $filepathe
            else
                #裡面沒這筆IP記錄，開始新增
                echo "新增記錄到iptables"
                #iptables -A INPUT -s $2/32 -p tcp -m multiport --dports 443,80 -m comment --comment "$ttoday Bot used Apply" -j ACCEPT
				sed -i '/^\-.*DROP/i\-A\ INPUT\ \-s\ '$2'\/32\ \-p\ tcp\ \-m\ multiport\ \-\-dports\ 443,80\ \-m\ comment\ \-\-comment\ \"'$ttoday'\ Bot\ used\ Apply\"\ \-j\ ACCEPT' $filepathe
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
    "3")
        echo "2"
	    grep "^[- ].*$2" $filepathe > /dev/null
	    if [ $? = 1 ] ;then
	        echo "開始將IP：$2 加入白名單"
            #看是否被註解
            grep "^#.*$2" $filepathe > /dev/null
		    if [ $? = 0 ] ;then
                #刪除註解
                echo "移掉舊記錄"
			    sed -i '/^#.*'$2'//g' $filepathe
            fi
            #裡面沒這筆IP記錄，開始新增
            echo "新增記錄到iptables"
            #iptables -A INPUT -s $2/32 -p tcp -m multiport --dports 443,80 -m comment --comment "$ttoday $3 used Apply" -j ACCEPT	     
            sed -i '/^\-.*DROP/i\-A\ INPUT\ \-s\ '$2'\/32\ \-p\ tcp\ \-m\ multiport\ \-\-dports\ 443,80\ \-m\ comment\ \-\-comment\ \"'$ttoday'\ '$3'\ used\ Apply\"\ \-j\ ACCEPT' $filepathe
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
    ;;
"del")
    #找那筆記錄
    grep "^[- ].*$2" $filepathe > /dev/null
	if [ $? = 0 ] ;then
	    sed -i 's/^-.*'$2'/#&/g' $filepathe
	    if [ $? = 0 ] ;then
	        echo "已將此筆記錄註解"
	    else
		    echo "註解失敗"
			exit
		fi
	else
	    echo "找不到記錄"
		exit
	fi
	echo "開始重新載入iptables"
    systemctl reload iptables
    if [ $? = 0 ] ;then
        echo "iptables重載成功"
    else
        echo "iptables重載失敗"
        exit
    fi
    ;;
"show")
    #判斷輸入參數個數
    case "$#" in
	"1")
        grep '^\-.*[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' $filepathe
	    ;;
	"2")
        grep "$2" $filepathe
		;;
	*)
	    echo "請不要輸入超過3個參數！"
		;;
	esac
	;;
"help")
    echo "說明："
	echo "使用語法：sh test.sh 指令 (IP) (申請者) ，上面括號內參數為選填，視情況使用"
	echo "指令有： add (新增)  del (刪除)  show (顯示記錄)"
	echo "IP：就是要綁定或解除的IP"
	echo "申請者：就是說要做的客服"
	echo "add與del時一定要輸入IP！"
	echo "只有add時申請者的參數有用到"
	echo "show的時候不帶IP就是看全部"
	;;
*)
    echo "第一個參數為必須參數，只有add、del、show及help可用！"
    ;;
esac
