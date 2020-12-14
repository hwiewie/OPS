#!/bin/bash
nfsarray=(`cat /proc/net/nfsfs/servers | sed -n '2,$p' | awk '{print $5}'|sort|uniq   2>/dev/null`)
length=${#nfsarray[@]}
printf "{\n"
printf  '\t'"\"data\":["
for ((i=0;i<$length;i++))
do
         printf '\n\t\t{'
         printf "\"{#NFS_SERVER}\":\"${nfsarray[$i]}\"}"
         if [ $i -lt $[$length-1] ];then
                 printf ','
         fi
done
printf  "\n\t]\n"
printf "}\n"
