#!/bin/bash
#取最近一段時間，看error log裡面是否有110 connection timeout事件，撈出事件，顯示時間、來源IP與訪問domain
cd /opt/logs/nginx/
anhour=`date '+%H:' -d '-10 minutes'`
FILESE=*60??.error.log
for fe in $FILESE
do
   n1=`grep -n $anhour $fe|head -1|cut -d ':' -f1`
   if [ ! -n "$n1" ] ;then
      continue
   fi
   n2=`wc -l $fe | awk '{print $1}'`
   sed -n ${n1},${n2}p $fe | grep -n "110: Connection timed out" | awk '{print $2, $17, $27}'
done
