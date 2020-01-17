#!/usr/bin/env python

import sys
from netaddr import *

f = open(r'today.txt').readlines()
iplists = f.readlines()
f.close()
f = open(r'news.txt').readlines()
newsip = f.readlines()
f.close()
rows = len(iplist)

N_ip_address = map(IPNetwork,newsip)
O_ip_address = map(IPNetwork,iplists)

if any(x in y for x in N_ip_address for y in O_ip_address):
    print(x)
