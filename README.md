# OPS
==環境設定==

監控軟體：Zabbix34_Nginx_PostgreSQL_PHP72.sh

Log收集(類似splunk)：ELK-install.sh

自動化運維軟體Saltstack：salt-install.sh

專案管理redmine-install.sh

事件追蹤系統Mantisbt：Mantisbt_install.sh

資產管理：GLPI-install.sh

自已架MediaWiki：MediaWiki_install.sh

安裝VPS：VPS_install.sh

其他軟體安裝：install_jenkins.sh

Zabbix API用法
~~~
operator monitor
zabbix_api.py
from zabbix_api import ZabbixAPI
zx = ZabbixAPI(server='http://172.16.100.97/zabbix/')
zx.login('username', 'password')
zx.call('event.get', {'output': zx.QUERY_EXTEND,'time_from':1499274518,'object':0,'value':1})
zx.call('trigger.get', {'output': zx.QUERY_EXTEND,'filter':{'value':1}})
zx.call('template.get', {'output': zx.QUERY_EXTEND,'hostid':10127,'groupid':1}) 
~~~
~~~
curl -i -X POST -H 'Content-type:application/json' -d '{"jsonrpc":"2.0","method":"user.login","params":{ "user":"myUserName","password":"myPassword"},"auth":null,"id":0}' https://zabbix-web.symcpe.net/api_jsonrpc.php
~~~

Zabbix monitor script and template https://github.com/easoncon/zabbix
saltstack combind zabbix to automatic deploy and monitor https://github.com/pengyao/salt-zabbix
zabbix Docker monitoring https://github.com/monitoringartist/zabbix-docker-monitoring

#splunk 語法
前台即時連線數
~~~
index=syslog Type=access | eval group_1=split(Hostname,"_"),group=mvindex(group_1,0),fnd=mvindex(group_1,1) | search group=$group$ fnd=FE | stats sum(connections) as sum by group | table sum
~~~
前台連線數
~~~
index=syslog Type=access | eval group_1=split(Hostname,"_"),group=mvindex(group_1,0),fnd=mvindex(group_1,1) | search group=$group$ fnd=FE | timechart span=5m values(connections) as "Client IP" by Hostname
~~~
日常作業
域名綁定(綁定與解除) 前台白名單(新增與移除) 後台白名單(新增與移除) RP維護(維護模式開啟與關閉) 主域名設定(設定A type record)

RP告警
失聯 可用資源過低(CPU、Ram、disk) Upstream異常(失聯、狀態碼異常)

服務異常
域名解析錯誤(沒cname、域名污染綁架) 服務無法開啟(告警 逾時 錯誤 很卡 不在服務區內) 後端服務異常(無法登入、無法更新)

大量服務異常
所有品牌服務告警(雲服務商網路ping lose、upstream失聯)

=======
E-Detective 網路監聽系統 
ObserveIT 跳板機

=======

[CDN Hub](https://github.com/qiniu/cdnprovider_auth)

[Informap](https://github.com/kttzd/informap)

動態CDN
動態的內容加速是做鏈路加速和安全保護.
1.動態內容對於源站是多線的高質量網絡, 無加速效果, 反而慢一點. 這是物理限制.
2.源站處於單地區覆蓋, 接入CDN可避免跨地區的網絡骨幹擁堵問題.
3.如果源站只有單線, 如電信. 那麼, CDN就能對聯通和移動網絡進行加速.
4.起到保護源站的作用, 什麼ddos, cc攻擊都能在CDN擋掉, 不會影響源站的正常服務.

========
網絡遊戲服務器注意事項，優化措施
1：IO操作是最大的性能消耗點，注意優化餘地很大。
2：算法數據結構。排序尋路算法的優化。 list,vector,hashmap的選擇。大數據尋址，不要考慮遍歷，注意考慮hash.
3：內存管理。重載new/delete，內存池，對像池的處理。
4：數據的提前準備和即時計算。
5：CPU方面的統計監視。邏輯幀計數（應當50ms以內）。
6：預分配池減少切換和調度，預處理的線程池和連接池等。
7：基與消息隊列的統計和信息監視框架。
8：CPU消耗排名：第一AOI同步，第二網絡發包I/O操作，第三技能/BUFF判定計算處理，第四定時器的頻率。
9：內存洩露檢測，內存訪問越界警惕，內存碎片的回收。
10：內存消耗排名：第一玩家對象包括其物品，第二網絡數據緩衝。
11：注意32位和64位的內存容錯。
12：減少不必要的分包發送。
13：減少重複包和重拷貝包的代價。
14：建議分緊急包（立刻發送）和非緊急包（定時輪訓發送）。
15：帶寬消耗排名：第一移動位置同步，第二對象加載，第三登陸突發包，第四狀態機定時器消息。
16：客戶端可做部分預判斷機制，部分操作盡量分包發送。
17：大量玩家聚集時，部分非緊急包進行丟棄。
18：注意數據庫單表內key數量。
19：活躍用戶和非活躍用戶的分割存取處理。
20：控制玩家操作對數據庫的操作頻率。
21：注意使用共享內存等方式對數據進行安全備份存儲。
22：注意安全策略，對內網進行IP檢查，對日誌進行記錄，任意兩環點內均使用加密算法會更佳。
23：實時注意對網關，數據庫等接口進行監察控制。
24：定時器應當存儲一個隊列，而非單向定位。
25：九宮格數據同步時，不需要直接進行九宮格的同步，對角色加一個AOI，基於圓方碰撞原理，拋棄不必要的格信息，可大幅節省。
26：客戶端做部分的預測機制，服務器檢測時注意時間戳問題。
27：定期心跳包，檢查死鏈接是必要的。
28：為了實現更加負責多種類的AI，AI尋路獨立服務器設計已經是必須的了。其次需要考慮的是聊天，同步。
29：服務器內網間可以考慮使用UDP。
30：注意所有內存池，對像池等的動態擴張分配。

1：以內存換取CPU的理念。
2：NPC不死理念。 (只會disable)
3：動態擴展理念，負載均衡理念。
4：客戶端不可信理念。
5：指針數據，消息均不可信理念。

6：盡量在客戶端進行最嚴格的校驗，擋住無謂的請求

7：能放在客戶端的功能，放在客戶端實現，服務器進行校驗即可
