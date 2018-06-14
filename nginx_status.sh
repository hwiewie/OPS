#!/bin/bash
# Description：zabbix監控nginx性能以及進程狀態
# Note：此腳本需要配置在被監控端，否則ping檢測將會得到不符合預期的結果
 
HOST="127.0.0.1"
PORT="80"
URI="/nginx_status"
 
# 檢測nginx進程是否存在
function ping {
    /sbin/pidof nginx | wc -l 
}
# 檢測nginx性能
function active {
    /usr/bin/curl "http://$HOST:$PORT/${URI}" 2>/dev/null| grep 'Active' | awk '{print $NF}'
}
function reading {
    /usr/bin/curl "http://$HOST:$PORT/${URI}" 2>/dev/null| grep 'Reading' | awk '{print $2}'
}
function writing {
    /usr/bin/curl "http://$HOST:$PORT/${URI}" 2>/dev/null| grep 'Writing' | awk '{print $4}'
}
function waiting {
    /usr/bin/curl "http://$HOST:$PORT/${URI}" 2>/dev/null| grep 'Waiting' | awk '{print $6}'
}
function accepts {
    /usr/bin/curl "http://$HOST:$PORT/${URI}" 2>/dev/null| awk NR==3 | awk '{print $1}'
}
function handled {
    /usr/bin/curl "http://$HOST:$PORT/${URI}" 2>/dev/null| awk NR==3 | awk '{print $2}'
}
function requests {
    /usr/bin/curl "http://$HOST:$PORT/${URI}" 2>/dev/null| awk NR==3 | awk '{print $3}'
}

# 執行function
$1
