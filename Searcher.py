#!/usr/bin/env python
#-*- coding:utf-8 -*-
#使用說明：
#需要安裝下列套件：
#unicodecsv,codecs
#需要下載ip2Region.py與資料庫
#wget https://raw.githubusercontent.com/lionsoul2014/ip2region/master/binding/python/ip2Region.py
#wget https://github.com/lionsoul2014/ip2region/blob/master/data/ip2region.db?raw=true -O ip2region.db
#用法：
#python Searcher.py 參數一
#當無參數時，可以手動輸入IP查詢，如要離開查詢介面，請輸入：quit
#當有參數時，會以參數開啟IP列表(CSV檔)，會在此CSV內新增二欄位：Country與City，會自動查出此IP所屬地區
#參數說明：
#參數一：輸入CSV檔，第一欄位為IP

import struct, sys, os, time
from ip2Region import Ip2Region
import unicodecsv as csv
#from langconv import *
import codecs

def testSearch():
    dbFile    = "ip2region.db"
    method    = 1
    algorithm = "b-tree"
    
    if (not os.path.isfile(dbFile)) or (not os.path.exists(dbFile)):
        print "[Error]: Specified db file is not exists."
        return 0

    print "initializing %s..." % (algorithm)
    print "+----------------------------------+"
    print "| ip2region test program           |"
    print "|                                  |"
    print "| Type 'quit' to exit program      |"
    print "+----------------------------------+"

    searcher = Ip2Region(dbFile);

    while True:
        line = raw_input("ip2region>> ")
        line = line.strip()

        if line == "":
            print "[Error]: Invalid ip address."
            continue

        if line == "quit":
            print "[Info]: Thanks for your use, Bye."
            break

        if not searcher.isip(line):
            print "[Error]: Invalid ip address."
            continue

        sTime = time.time() * 1000
        if method == 1:
            data = searcher.btreeSearch(line)
        elif method == 2:
            data = searcher.binarySearch(line)
        else:
            data = searcher.memorySearch(line)
        eTime = time.time() * 1000

        if isinstance(data, dict):
            print "%s|%s in %f millseconds" % (data["city_id"], data["region"], eTime-sTime)
        else:
            print "[Error]: ", data

    searcher.close()

def csvSearch():
    csvFile = sys.argv[1]
    dbFile    = "ip2region.db"
    #method = 3 #(1:btree 中 2:binary 慢 3:memory 快)
    #algorithm = "memory" #依method設定值來設定
    searcher = Ip2Region(dbFile);
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
                if not searcher.isip(ipa):
                	print "不合法IP：" ,ipa
                    continue

                data = searcher.memorySearch(ipa)
            
                temp=data["region"].split('|')
                if temp[3] != '0':
                    city = temp[3]
                elif temp[2] != '0':
                    city = temp[2]
                else:
                    city = "空"
                if temp[0] != '0':
                    country = temp[0]
                else:
                    country = "空"
                row.append(country)
                row.append(city)
                all.append(row)
            writer.writerows(all)
            
if __name__ == "__main__":
#    reload(sys)
#    sys.setdefaultencoding("gb2312")
    llen = len(sys.argv)
    if llen < 2:
        testSearch()
    elif llen == 2:
        csvSearch()
    
