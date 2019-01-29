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

for fn in $dnsservers; do
  speeds=`host -a -t a google.com $fn | awk '/^Received / {print $7}'`
  echo "DNS $fn query time: $speeds"
done
