#!/bin/bash
#取得目前DNS設定
dnsservers=`cat /etc/resolv.conf | awk '/^nameserver / {print $2}'`
for fn in $dnsservers; do
  speeds=`host -a -t a demo.cqgame.games $fn | awk '/^Received / {print $7}'`
  echo "DNS $fn query time: $speeds"
done
