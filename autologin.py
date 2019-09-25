#!/usr/bin/env python
#-*- coding: UTF-8 -*-
# filename: AutoLogin.py
 
from __future__ import unicode_literals
import urllib2
import cookielib
import urllib
import Image
from cStringIO import StringIO
import re
from pytesser import *
 
LOGIN_URL = 'http://*.*.*.*/lr.sm' #网站就隐了，被发现了估计验证码加强了就不好整了-_-||
IMAGE_URL = 'http://*.*.*.*/image'
USER = 'yourusername'
PWD = 'yourpassword'
 
### OCR using pytesser ###
img_file=urllib2.urlopen(IMAGE_URL)
img= StringIO(img_file.read())
checkImg= Image.open(img)
ocr_str= image_to_string(checkImg).lower()
CODE=''.join(ocr_str.split())
 
postdata=urllib.urlencode({
    'user.nick':USER,
    'password':PWD,
    'validationCode':CODE,
})
 
headers={
    'User-Agent':'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20100101 Firefox/13.0.1',
    'Referer':LOGIN_URL
}
 
cookie_support = urllib2.HTTPCookieProcessor(cookielib.CookieJar())
opener = urllib2.build_opener(cookie_support, urllib2.HTTPHandler)
urllib2.install_opener(opener)
 
req = urllib2.Request( url = LOGIN_URL, data = postdata, headers = headers )
 
result = urllib2.urlopen(req).read()
decoded_result=result.decode('utf-8')
if re.search('{} **欢迎您'.format(USER), decoded_result): #隐去网站名称...
    print 'Logged in successfully!'
else:
    with open('result.html','w') as f:
        f.write(result)
    print 'Logged in failed, check result.html file for details'
