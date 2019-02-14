#!/usr/bin/env python
#-*- coding:utf-8 -*-
# 必要套件
# unicodecsv , codecs , geoip2 
# GeoIP資料庫
# wget http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.tar.gz
# 請將 GeoLite2-City.mmdb 解出來放在程式所在目錄內
# 用法：
# python SGeoIP2.py 要查詢的IP列表.csv
# IP列表CSV檔案格式說明：
# 第一欄位名稱為IP，下面列出所有要查詢的IP列表
# 程式會將結果另存為 output.csv
import struct, sys, os, time
import unicodecsv as csv
import codecs
import geoip2.database
import IPy

geoipreader = geoip2.database.Reader('GeoLite2-City.mmdb')
llen = len(sys.argv)
csvFile = sys.argv[1]
with open(csvFile,'r') as sf:
    with open('output.csv', 'w') as wf:
        reader = csv.reader(sf,encoding='utf-8')
        wf.write(codecs.BOM_UTF8)
        writer = csv.writer(wf, dialect='excel')
        all = []
        head_row = next(reader)  #讀取欄位名稱
        head_row.append('Country')
        head_row.append('City')
        all.append(head_row)
        for row in reader: ##就readCSV裡的所有資料(以列為單位)
            ipa = row[0] ##請輸入IP所在欄位(從0開始)##
            if IPy.IP(ipa).iptype() == 'PRIVATE':
                continue
            response = geoipreader.city(ipa)
            city = response.city.name
            country = response.country.name
            print("IP:",ipa," Country:",country," City:",city)
            row.append(country)
            row.append(city)
            all.append(row)
        writer.writerows(all)
geoipreader.close()
