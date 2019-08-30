#!/usr/bin/python
#-*-coding:utf-8-*-
import httplib
import urllib
from hashlib import md5
import json

class CdnRefresh():
    def __init__(self, urllist):
        self.urllist = urllist
        self.cc = {"username: ", "pass" ,"", #藍汛API的用戶名密碼
        "host: ","r.chinacache.com",
        "path: ","/content/refresh",
        "port: 443",
        "https: True",
        "method: POST",
        "domain: ['static']" #對應的域名前綴
        }
        self.cnc = {"username": "", #網宿API的用戶名密碼
                    "pass": "",
                    "host": "wscp.lxdns.com",
                    "port": 8080,
                    "https": False,
                    "method": "GET",
                    "path": "/wsCP/servlet/contReceiver",
                    "domain": ['static1']} #對應的域名前綴
        self.urllist = urllist

    def md5_str(self, str):
        m = md5()
        m.update(str)
        return m.hexdigest()

    def connect(self, args, body):
        headers = {"Content-Type": "application/x-www-form-urlencoded",
                   "Connection": "Keep-Alive"}
        if args["https"]:
            conn = httplib.HTTPSConnection(args["host"], port=args['port'])
            conn.request(method=args["method"],
                         url=args["path"],
                         body=body, headers=headers)
        else:
            conn = httplib.HTTPConnection(args["host"], port=args['port'])
            conn.request(method=args["method"],
                         url=args["path"] + "?" + body)
        response = conn.getresponse()
        return_code = response.read()
        if response.status == 200:
            return {"success": return_code}
        else:
            return {"failed": return_code}

    def urlparam(self, md5=False):
        task = json.dumps({"urls": self.urllist})
        cc = self.cc
        cnc = self.cnc
        params = urllib.urlencode({"username": cc["username"],
                                   "password": cc["pass"],
                                   "task": task,
                                   "callback": {"email": "yw@babeltime.com",
                                                "acptNotice": "true"}})
        if md5:
            urlstr = ""
            for h in self.urllist:
                urlstr += h.split("//")[1] + ";"
            urlstr = urlstr.rstrip(";")
            passwd = self.md5_str(cnc["username"] +
                                  cnc["pass"] + urlstr)
            params = urllib.urlencode({"username": cnc["username"],
                                       "passwd": passwd, "url": urlstr})
        return params

    def refresh(self):
        cnc = []
        cc = []
        for url in self.urllist:
            url = url.strip()
            for domain in self.cnc['domain']:
                if url.startswith(domain, 7):
                    cnc.append(url)
                    continue
            for domain in self.cc['domain']:
                if url.startswith(domain, 7):
                    cc.append(url)
                    continue
        result = {}
        if cnc:
            params = self.urlparam()
            result = self.connect(self.cnc, params)
        if cc:
            params = self.urlparam(md5=True)
            result = self.connect(self.cnc, params)
        return result


if __name__ == "__main__":

    u = CdnRefresh(["http://static1.xxxxx.com/hx.png",
                    "http://static1.xxxxx.com/h2.png"])
    print u.refresh()