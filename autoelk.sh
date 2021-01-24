#!/bin/bash
todays=$(date +"%s")
curl 'localhost:9200/_cat/indices?h=i,creation.date.string' | awk '{print $1","$2}'  > /opt/list.txt
indexlist="/opt/list.txt"
while read -r index; do
indexname=`echo $index | cut -d',' -f1`
#echo $indexname
indexdate=`echo $index | cut -d',' -f2`
#echo $indexdate
indexdate_s=$(date -d "$indexdate" +%s)
#echo $indexdate_s
date_diff=$(( (todays - indexdate_s) / 86400 ))
#echo $date_diff
if [ $date_diff -gt 3 ];then
    echo "$indexname will be clcosed"
    # curl -X POST 'localhost:9200/$indexname/_close'
fi
if [ $date_diff -gt 7 ];then
    echo "$indexname will be delete"
    # curl -XDELETE localhost:9200/$indexname
fi
done<"${indexlist}"
