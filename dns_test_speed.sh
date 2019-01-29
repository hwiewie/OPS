#!/bin/bash
function helps {
    echo "說明："
    echo "使用語法：sh dns_test_speed.sh 指令 域名，可以輸入一個參數"
    echo "參數一，域名：就是要測試查詢的域名，若未輸入預設查詢域名為：google.com"
}
#取得目前DNS設定
dnsservers=`cat /etc/resolv.conf | awk '/^nameserver / {print $2}'`
#判斷輸入參數#[ $# = 0 ]
if [[ ! -n $1 ]]; then
   echo "you have not input any domain,default domain: google.com"
   testdomain="google.com"
else
   echo "test domain is: $testdomain"
   testdomain=$1
fi
#列出可查詢DNS查詢該域名所花費時間
for fn in $dnsservers; do
   speeds=`host -a -t a $testdomain $fn | awk '/^Received / {print $7}'`
   echo "DNS $fn query time: $speeds ms"
done
