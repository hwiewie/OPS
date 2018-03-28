# OPS
==環境設定==
監控軟體：Zabbix34_Nginx_PostgreSQL_PHP72.sh
Log收集(類似splunk)：ELS-install.sh
自動化運維軟體Saltstack：salt-install.sh
事件追蹤系統Mantisbt：Mantisbt_install.sh
自已架MediaWiki：MediaWiki_install.sh
安裝VPS：VPS_install.sh
其他軟體安裝：install_jenkins.sh

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

日常作業
域名綁定(綁定與解除) 前台白名單(新增與移除) 後台白名單(新增與移除) RP維護(維護模式開啟與關閉) 主域名設定(設定A type record)

RP告警
失聯 可用資源過低(CPU、Ram、disk) Upstream異常(失聯、狀態碼異常)

服務異常
域名解析錯誤(沒cname、域名污染綁架) 服務無法開啟(告警 逾時 錯誤 很卡 不在服務區內) 後端服務異常(無法登入、無法更新)

大量服務異常
所有品牌服務告警(雲服務商網路ping lose、upstream失聯)
