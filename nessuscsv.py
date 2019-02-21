#!/usr/bin/env python
#-*- coding:utf-8 -*-
import sys
import unicodecsv as csv
#import codecs
#from pandas import Series, DataFrame  
import numpy as np
import pandas as pd

def countcsv():
    csvFile = 'nessus2018_09_20_12_01_18.csv' #sys.argv[1]
    outputcsv = 'result.csv'#sys.argv[2]
    df=pd.DataFrame(pd.read_csv(csvFile,header=0))
    #df=pd.DataFrame(pd.read_excel('name.xlsx'))
    #cve=df['CVE'].unique()
    risks=df['Risk'].unique()
    hosts=df['Host'].unique()
    #protocol=df['Protocol'].unique()
    #port=df['Port'].unique()
    #print "%s" %host
    #print "%s" %risk
    #list=np.zeros((len(url),len(city)),dtype='int32')
    #print "%d %d %d" %(len(url),len(city),len(list)) #
#    print hostrisk
#    for s in range(0,len(df)):
#        if df['Risk'] == "None":
#            continue
    #for h in range(0,len(host)):
#            if df['Host'] == host[h]:
#                for case in switch(df['Risk']):
#                    if case('Low'):
        #for r in range(0,len(risk)):
            #print "%s" %hostrisk[(hostrisk['host']==host[h])]
            #good=df[(df['Host']==host[h])&(df['Risk']==risk[r])]
            #print "%s" %good
            #st[h][r]=len(df)
    print "%s" %df.groupby(['Host','Risk']).agg('count')
    #ds=pd.DataFrame.from_dict(data=df,orient=hosts)
    #print "%s" %ds
 #   for s in range(0,len(url)):
        #print "%s" %(list[0][s-1]) #
 #       for t in range(0,len(city)):
            #print "%s" %(list[0][t-1])
 #           good=df[(df['url']==url[s])&(df['City']==city[t])]
            #print "%s" %(good.len) #
#            list[s][t]=len(good)
#            print "%d," %(len(good)),
#        print ""
#    ds=pd.DataFrame.from_dict(data=list,index=url,columns=city)
#    with open(outputcsv, 'w') as wf:
#        wf.write(codecs.BOM_UTF8) #防止寫中文出現亂碼
#        writer = csv.writer(wf, dialect='excel')
#        writer.writerows(ds)
    #ds=pd.DataFrame(ds)
    #ds.to_csv(outputcsv,encoding='utf_8_sig', errors='ignore') #sep=',',index_label='serial'
    #np.savetxt(outputcsv, list, delimiter=",")

if __name__ == "__main__":
    countcsv()
