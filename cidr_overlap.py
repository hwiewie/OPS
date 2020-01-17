#!/usr/bin/env python

import sys
from netaddr import *

# Read from stdin
data = sys.stdin.readlines()

if len(data) == 1:
    # Input from echo
    data = data[0].split()

# Create an IPSet of the CIDR blocks
# IPSet automatically runs cidr_merge
nets = IPSet(data)

# Output the superset of CIDR blocks
#for cidr in nets.iter_cidrs():
#    print cidr

def is_overlap(old, new):
    old_net = netaddr.IPNetwork(old)
    new_net = netaddr.IPNetwork(new)
    return old_net in new_net or new_net in old_net
    
