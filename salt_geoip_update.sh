#!/bin/bash
#判斷是否有輸入檔名
if [[ ! -n $1 ]]; then
   #找今天更新的GeoIP.dat(只要檔名)
   geoipdata=`ls -al --time-style=+%D *.txt | grep "`date +'%D'`" | awk '{print $7}' | sed 's/\/etc\/salt\/deploy\///'`
else
   geoipdata=$1
fi
#用salt去deploy檔案到所有前台
salt "*fe*" cp.get_file "salt://geoip/$geoipdata" /root/geoip.dat
#睡20秒
sleep 20
#用salt讓前台把geoip.dat放到GeoIP的目錄下
salt "*fe*" cmd.run "sh upgrade_geoip.sh"
#睡30秒
sleep 30
#測試服務是否正常
salt "*fe*" cmd.run "geoiplookup 168.95.1.1"
