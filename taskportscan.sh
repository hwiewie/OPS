#!/bin/sh
TARGETS="all.txt"
OPTIONS="-v -T4 -p- -n"
date=`date +%F`
cd ~/scans
echo `pwd`
nmap $OPTIONS -iL $TARGETS -oA scan-$date > /dev/null
if [ -e scan-prev.xml ]; then
        ndiff scan-prev.xml scan-$date.xml > diff-$date
        echo "*** NDIFF RESULTS ***"
        cat diff-$date
        echo
fi
echo "*** NMAP RESULTS ***"
cat scan-$date.nmap
ln -sf scan-$date.xml scan-prev.xml
