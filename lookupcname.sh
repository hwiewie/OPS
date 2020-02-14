#!/bin/bash
#doman.txt放要測試域名
function diglookup()
{
	value1="${1}"
	result=`dig $value1 cname | grep '^[^;].*CNAME' | awk '{print $5}'`
	echo "$value1,$result"
}

function getentlookup()
{
	nslookup -type=CNAME 8488vip.com | grep canonical | awk '{print $5 }'
}

domainfile=domain.txt
if [[ -n $domainfile ]];then
	exec < $domainfile
	while read line
	do
		result=$(diglookup $line)
		#echo $result
	done
else
	echo "no"
	exit
fi
