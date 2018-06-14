#!/bin/bash
#This script is used to get tcp and udp connection status!

Tcp_Status=$1
Tmp_File=/tmp/Tcp_Status.txt
/bin/netstat -an|awk '/^tcp/{++S[$NF]}END{for(a in S) print a,S[a]}' > $Tmp_File
case $Tcp_Status in
     TIME_WAIT)
              num=`awk '/TIME_WAIT/ {print $NF}' $Tmp_File`
              if [ -z $num ];then
                 echo 0
              else
                 echo $num
              fi
              ;;
     CLOSE_WAIT)
              num=`awk '/CLOSE_WAIT/ {print $NF}' $Tmp_File`
              if [ -z $num ];then
                 echo 0
              else
                 echo $num
              fi
              ;;
     SYN_SENT)
              num=`awk '/SYN_SENT/ {print $NF}' $Tmp_File`
              if [ -z $num ];then
                 echo 0
              else
                 echo $num
              fi
              ;;
     ESTABLISHED)
              num=`awk '/ESTABLISHED/ {print $NF}' $Tmp_File`
              if [ -z $num ];then
                 echo 0
              else
                 echo $num
              fi
              ;;
     FIN_WAIT2)
              num=`awk '/FIN_WAIT2/ {print $NF}' $Tmp_File`
              if [ -z $num ];then
                 echo 0
              else
                 echo $num
              fi
              ;;
     LISTEN)
              num=`awk '/LISTEN/ {print $NF}' $Tmp_File`
              if [ -z $num ];then
                 echo 0
              else
                 echo $num
              fi
              ;;
     SYN-RECEIVED)
              num=`awk '/SYN-RECEIVED/ {print $NF}' $Tmp_File`
              if [ -z $num ];then
                 echo 0
              else
                 echo $num
              fi
              ;;
     FIN-WAIT-1)
              num=`awk '/FIN-WAIT-1/ {print $NF}' $Tmp_File`
              if [ -z $num ];then
                 echo 0
              else
                 echo $num
              fi
              ;;
     CLOSING)
              num=`awk '/CLOSING/ {print $NF}' $Tmp_File`
              if [ -z $num ];then
                 echo 0
              else
                 echo $num
              fi
              ;;
     LAST-ACK)
              num=`awk '/LAST-ACK/ {print $NF}' $Tmp_File`
              if [ -z $num ];then
                 echo 0
              else
                 echo $num
              fi
              ;;
     CLOSED)
              num=`awk '/CLOSED/ {print $NF}' $Tmp_File`
              if [ -z $num ];then
                 echo 0
              else
                 echo $num
              fi
              ;;
     UNKNOWN)
              num=`awk '/UNKNOWN/ {print $NF}' $Tmp_File`
              if [ -z $num ];then
                 echo 0
              else
                 echo $num
              fi
              ;;
           *)
             echo -e "\033[31m Usage:$0 [TIME_WAIT|CLOSE_WAIT|SYN_SENT|ESTABLISHED|FIN_WAIT2|LISTEN|SYN-RECEIVED|FIN-WAIT-1|CLOSING|LAST-ACK|CLOSED|UNKNOWN]\033[0m"
            ;;
esac
