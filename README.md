# OPS
operator monitor
zabbix_api.py
from zabbix_api import ZabbixAPI
zx = ZabbixAPI(server='http://172.16.100.97/zabbix/')
zx.login('username', 'password')
zx.call('event.get', {'output': zx.QUERY_EXTEND,'time_from':1499274518,'object':0,'value':1})
zx.call('trigger.get', {'output': zx.QUERY_EXTEND,'filter':{'value':1}})
zx.call('template.get', {'output': zx.QUERY_EXTEND,'hostid':10127,'groupid':1}) 


curl -i -X POST -H 'Content-type:application/json' -d '{"jsonrpc":"2.0","method":"user.login","params":{ "user":"myUserName","password":"myPassword"},"auth":null,"id":0}' https://zabbix-web.symcpe.net/api_jsonrpc.php


Zabbix monitor script and template https://github.com/easoncon/zabbix
saltstack combind zabbix to automatic deploy and monitor https://github.com/pengyao/salt-zabbix
zabbix Docker monitoring https://github.com/monitoringartist/zabbix-docker-monitoring


前台即時連線數
index=syslog Type=access | eval group_1=split(Hostname,"_"),group=mvindex(group_1,0),fnd=mvindex(group_1,1) | search group=$group$ fnd=FE | stats sum(connections) as sum by group | table sum

前台連線數
index=syslog Type=access | eval group_1=split(Hostname,"_"),group=mvindex(group_1,0),fnd=mvindex(group_1,1) | search group=$group$ fnd=FE | timechart span=5m values(connections) as "Client IP" by Hostname
