#!/usr/bin/env python
# -*- coding: utf-8 -*-
 
import requests
import json
import datetime
import hmac
import hashlib
import base64
import sys
 
# auth
username = "XXX"
apiKey = b"XXXXXXXXX"
 
# domain
domain="http://www.abc.com/"
 
# time
now = datetime.datetime.now()
nowTime = now.strftime('%a, %d %b %Y %H:%M:%S GMT')
nowTime_bytes = bytes(nowTime).encode('utf-8')
 
# headers 
headers = {
    "Content-type": "application/json",
    "Date": nowTime
}
 
# token
value = hmac.new(apiKey, nowTime_bytes, hashlib.sha1).digest()
token = base64.b64encode(value).rstrip()
 
# api url
url = "https://open.chinanetcenter.com/ccm/purge/ItemIdReceiver"
 
# post data
data = json.dumps({
    "dirs": [
        domain
    ],
})
 
# post
r = requests.post(url, data=data, headers=headers, auth=(username, token))
#result = json.loads(r.text)
result = r.text 
print(result)
