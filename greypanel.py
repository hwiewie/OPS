# -*- coding: utf-8 -*-
import sys
import time
import urllib
import shutil
import pytesser
import requests
from lxml import etree

class Grey
    def initialize(host,port)
    

config = {'gid': 1}
def parse(s, html, idx):
result = {}
tree = etree.HTML(html)
try:
result['lt'] = tree.xpath('//input[@name="lt"]/@value')[0]
result['execution'] = tree.xpath('//input[@name="execution"]/@value')[0]
result['path'] = tree.xpath('//form[@id="fm1"]/@action')[0]
except IndexError, e:
return None
valimg = None
valimgs = tree.xpath('//img[@id="yanzheng"]/@src')
if len(valimgs) > 0:
valimg = valimgs[0]
validateCode = None
if valimg:
fname = 'img/'   str(idx)   '_'   str(config['gid'])   '.jpg'
config['gid'] = config['gid']   1
ri = s.get("https://passport.csdn.net"   valimg)
with open(fname, 'wb') as f:
for chk in ri:
f.write(chk)
f.close()
validateCode = pytesser.image_file_to_string(fname)
validateCode = validateCode.strip()
validateCode = validateCode.replace(' ', '')
validateCode = validateCode.replace('\n', '')
result['validateCode'] = validateCode
return result
def login(usr, pwd, idx):
s = requests.Session()
r = s.get('https://passport.csdn.net/account/login',
headers={'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:41.0) Gecko/20100101 Firefox/41.0', 'Host': 'passport.csdn.net', })
while True:
res = parse(s, r.text, idx)
if res == None:
return False
url = 'https://passport.csdn.net'   res['path']
form = {'username': usr, 'password':pwd, '_eventId':'submit', 'execution':res['execution'], 'lt':res['lt'],}
if res.has_key('validateCode'):
form['validateCode'] = res['validateCode']
s.headers.update({
'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:41.0) Gecko/20100101 Firefox/41.0',
'Accept-Language': 'zh-CN,zh;q=0.8,en-US;q=0.6,en;q=0.4',
'Content-Type': 'application/x-www-form-urlencoded',
'Host': 'passport.csdn.net',
'Origin': 'https://passport.csdn.net',
'Referer': 'https://passport.csdn.net/account/login',
'Upgrade-Insecure-Requests': 1,
})
r = s.post(url, data=form)
tree = etree.HTML(r.text)
err_strs = tree.xpath('//span[@id="error-message"]/text()')
if len(err_strs) == 0:
return True
err_str = err_strs[0]
print err_str
err = err_str.encode('utf8')
validate_code_err = '驗證碼錯誤'
usr_pass_err = '帳戶名或登入密碼不正確，請重新輸入'
try_later_err = '登入失敗連續超過5次，請10分鐘後再試'
if err[:5] == validate_code_err[:5]:
pass
elif err[:5] == usr_pass_err[:5]:
return False
elif err[:5] == try_later_err[:5]:
return False
else:
return True
if __name__ == '__main__':
main(sys.argv[1], sys.argv[2], 0)