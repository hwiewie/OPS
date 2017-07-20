#!/bin/bash
#取前一個小時到現在VPS連進來的access log，並存到/root/a.txt內，而error log存到/root/e.txt內
cd /opt/logs/nginx/
anhour=`date +%d\/%b\/%Y:%H -d '-1 hours'`
tenminutes=`date '+%H:' -d '-10 minutes'`
FILESA=*access.log
FILESE=*error.log
for fa in $FILESA
do
   n1=`grep -n $anhour $f|head -1|cut -d ':' -f1`
   if [ ! -n "$n1" ] ;then
      continue
   fi
   n2=`wc -l $fa | awk '{print $1}'`
   #echo "sed -n ${n1},${n2}p"
   sed -n ${n1},${n2}p $fa | grep -e "122.228.244.207\|121.201.126.154\|218.65.131.23\|121.18.238.84\|121.18.238.84\|122.228.244.207\|123.249.34.189\|222.88.94.206\|117.21.191.101\|119.90.126.103\|124.232.137.43\|118.123.243.214\|27.221.52.39\|221.181.73.38\|60.169.77.177\|59.45.175.118\|202.111.175.61\|219.153.49.198\|219.138.135.102\|125.211.218.83\|111.161.65.109\|117.34.109.53\|124.164.232.146" >> /root/a.txt
done
for fe in $FILESE
do
   n1=`grep -n $tenminutes $fe|head -1|cut -d ':' -f1`
   if [ ! -n "$n1" ] ;then
      continue
   fi
   n2=`wc -l $fe | awk '{print $1}'`
   #echo "sed -n ${n1},${n2}p"
   sed -n ${n1},${n2}p $fe | grep -n "110: Connection timed out" | awk '{print $2, $17, $27}' >> /root/e.txt
done
