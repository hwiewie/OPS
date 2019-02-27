#!/usr/bin/env python
#-*- coding:utf-8 -*-
import sys
import unicodecsv as csv
import codecs
#from pandas import Series, DataFrame  
import numpy as np
import pandas as pd

def countcsv():
    csvFile = sys.argv[1]
    outputcsv = sys.argv[2]
    df=pd.DataFrame(pd.read_csv(csvFile,header=0))
    #df=pd.DataFrame(pd.read_excel('name.xlsx'))
    url=df['url'].unique()#df['url'].drop_duplicates()
    city=df['City'].unique()#df['City'].drop_duplicates()
    list=np.zeros((len(url),len(city)),dtype='int32')
    print "%d %d %d" %(len(url),len(city),len(list)) #
    for x in range (0, len(url)):
        print "%s" %(url[x-1]) #
        #list[x][0]=url[x-1]
    for y in range (0, len(city)):
        print "%s," %(city[y-1]), #
    print ""
        #list[0][y]=city[y-1]
    for s in range(0,len(url)):
        #print "%s" %(list[0][s-1]) #
        for t in range(0,len(city)):
            #print "%s" %(list[0][t-1])
            good=df[(df['url']==url[s])&(df['City']==city[t])]
            #print "%s" %(good.len) #
            list[s][t]=len(good)
            print "%d," %(len(good)),
        print ""
    ds=pd.DataFrame.from_dict(data=list,index=url,columns=city)
    with open(outputcsv, 'w') as wf:
        wf.write(codecs.BOM_UTF8) #防止寫中文出現亂碼
        writer = csv.writer(wf, dialect='excel')
        writer.writerows(ds)
    #ds=pd.DataFrame(ds)
    #ds.to_csv(outputcsv,encoding='utf_8_sig', errors='ignore') #sep=',',index_label='serial'
    #np.savetxt(outputcsv, list, delimiter=",")

if __name__ == "__main__":
    countcsv()
