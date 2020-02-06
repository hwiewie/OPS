#！/bin/bash
DELTIME=6
INDEX_LOGST="logstash-ltm-index-"
SERVER_PORT="127.0.0.1:9200"
#INDEXS_ALL=$(curl -XGET "http://${SERVER_PORT}/_cat/indices?v" | awk '{print $3}')
#INDEXS_KEY_LOGST=$(curl -XGET "http://${SERVER_PORT}/_cat/indices?v"| grep "$INDEX_LOGST" | awk '{print $3}')
seconds=`date +%Y.%m.%d -d "-$DELTIME days"`
#date +%Y.%m.%d -d '-1 days'
#curl -XDELETE -u elastic:admins-1 'http://127.0.0.1:9200/logstash-ltm-index-2020.01.31'
#echo $seconds
delResult=`curl -XDELETE "http://${SERVER_PORT}/${INDEX_LOGST}${seconds}?pretty" |sed -n '2p'`
#curl -XGET "http://127.0.0.1:9200/_cat/indices?v&h=i" | grep logstash-ltm-index-*
#echo "http://${SERVER_PORT}/${INDEX_LOGST}$seconds"
echo $delResult
