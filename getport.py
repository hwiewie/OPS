#!/usr/bin/env python
#-*- coding:utf-8 -*-
import sys
import os
import unicodecsv as csv
import codecs
import numpy as np
import pandas as pd

def getport(csvFile):
    df=pd.DataFrame(pd.read_csv(csvFile,header=0))
    ports=df['port'].sort_values().unique()
    np.savetxt(r'port.txt',ports,fmt='%d')

if __name__ == "__main__":
    csvFile='report.csv'
    if os.path.exists("port.txt"):
        os.remove("port.txt")
    getport(csvFile)
