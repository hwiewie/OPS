# -*- coding: utf-8 -*-
import requests
import logging
import sys
#這兩行可以在httplib級別進行調試(requests->urllib3->http.client)
#你會看到REQUEST，包括HEADERS和DATA，和RESPONSE與HEADERS但沒有DATA
#唯一缺少的是沒有記錄的response.body
try:
    import http.client as http_client
except ImportError:
    # Python 2
    import httplib as http_client
http_client.HTTPConnection.debuglevel = 1

#您必須初始化日誌記錄，否則您將看不到調試輸出
logging.basicConfig()
logging.getLogger().setLevel(logging.DEBUG)
requests_log = logging.getLogger("requests.packages.urllib3")
requests_log.setLevel(logging.DEBUG)
requests_log.propagate = True

args = sys.argv[1:]
if not args:
	url = 'http://lecaike.com'
else :
	url = args[0]
if not url.startswith('http'):
	url = 'http://' + url
r = requests.get(url,timeout=5)	#用get的方式，設定超過5秒timeout
print(r.url, r.status_code,r.history)
if not r.status_code == requests.codes.ok:	#如果網頁有錯誤
	r.raise_for_status()
print(r.headers)	#
#print(r.content)	#回傳內容
#print(r.text)	#網頁內容
if r.status_code == requests.codes.ok:
    print(r.encoding)
print(r.Session())
