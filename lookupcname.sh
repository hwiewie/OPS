#!/bin/bash
function diglookup()
{
	value1="${1}"
	return `dig $value1 cname | grep '^[^;]CNAME'`
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
		echo $result
	done
else
	echo "no"
	exit
fi
