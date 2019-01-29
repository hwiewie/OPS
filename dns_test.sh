#!/bin/bash
#取得目前DNS設定
dnsservers=`cat /etc/resolv.conf | awk '/^nameserver / {print $2}'`
#判斷輸入參數#[ $# = 0 ]
if [[ ! -n $1 ]]; then
   echo "you have not input any domain,default domain: google.com"
   testdomain="google.com"
else
   testdomain=$1
fi
#列出可查詢DNS查詢該域名所花費時間
for fn in $dnsservers; do
  speeds=`host -a -t a $testdomain $fn | awk '/^Received / {print $7}'`
  echo "DNS $fn query time: $speeds ms"
done
