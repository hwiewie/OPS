#!/bin/bash
#用法：後面帶4個參數
#參數1：[status|failed|min|avg|max|loss]
#參數2：域名
#參數3：端口號
#參數4：[http|https]
metric=$1  
host=$2  
port=$3  
proto=$4
filepathe=/tmp/httping
if [ -d $filepathe ];then
    echo "OK" > /dev/null
else
    mkdir $filepathe
fi
tmp_file=/tmp/httping/${host}_${metric}_httping_status.txt  
if [ $proto == "https" ];then  
/bin/httping -c3 -t5 -l $proto://$host:$port > $tmp_file  
    case $metric in  
        status)  
        output=$(cat $tmp_file |grep connected |wc -l )  
        if [ $output -eq 3 ];then  
         output=1  
        echo $output  
        else  
             output=0  
        echo $output  
        fi  
        ;;  
        failed)  
            output=$(cat $tmp_file |grep failed|awk '{print $5}'|awk -F'%' '{print $1}' )  
            if [ "$output" == "" ];then  
             echo 100  
          else  
             echo $output  
          fi  
            ;;  
        min)  
          output=$( cat $tmp_file|grep min|awk '{print $4}'|awk -F/ '{print $1}' )  
          if [ "$output" == "" ];then  
             echo 0  
          else  
             echo $output  
          fi  
        ;;  
        avg)  
            output=$(cat $tmp_file|grep avg|awk '{print $4}'|awk -F/ '{print $2}')  
          if [ "$output" == "" ];then  
             echo 0  
          else  
             echo $output  
          fi  
            ;;  
        max)  
                output=$(cat $tmp_file|grep max|awk '{print $4}'|awk -F/ '{print $3}')  
          if [ "$output" == "" ];then  
            echo 0  
          else  
             echo $output  
          fi  
            ;;
        loss)
            output=$(cat $tmp_file|grep ok|awk '{print $5}' |awk -F% '{print $1}')
          if [ "$output" == "" ];then
            echo 0  
          else
             echo $output  
          fi
            ;;
        *)  
        echo -e "\e[033mUsage: sh  $0 [status|failed|min|avg|max|loss]\e[0m"  
       esac  
elif [ $proto == "http" ];then  
    /bin/httping -c3 -t5  $proto://$host:$port > $tmp_file  
    case $metric in  
            status)  
        output=$(cat $tmp_file |grep connected |wc -l )  
        if [ $output -eq 3 ];then  
           output=1  
        echo $output  
        else  
         output=0  
         echo   $output  
        fi  
        ;;  
        failed)  
            output=$(cat $tmp_file |grep failed|awk '{print $5}'|awk -F'%' '{print $1}' )  
            if [ "$output" == "" ];then  
             echo 100  
          else  
             echo $output  
          fi  
            ;;  
        min)  
          output=$( cat $tmp_file|grep min|awk '{print $4}'|awk -F/ '{print $1}' )  
          if [ "$output" == "" ];then  
             echo 0  
          else  
             echo $output  
          fi  
        ;;  
        avg)  
            output=$(cat $tmp_file|grep avg|awk '{print $4}'|awk -F/ '{print $2}')  
          if [ "$output" == "" ];then  
             echo 0  
          else  
             echo $output  
          fi  
            ;;  
        max)  
                output=$(cat $tmp_file|grep max|awk '{print $4}'|awk -F/ '{print $3}')  
          if [ "$output" == "" ];then  
             echo 0  
          else  
             echo $output  
          fi  
            ;;
        loss)
             output=$(cat $tmp_file|grep ok|awk '{print $5}' |awk -F% '{print $1}') 
          if [ "$output" == "" ];then
             echo 0  
          else
             echo $output  
          fi
            ;;
        *)  
        echo -e "\e[033mUsage: sh  $0 [status|failed|min|avg|max|loss]\e[0m"  
       esac  
else  
    echo "error parm " $proto >/tmp/httping/error.log  
fi
