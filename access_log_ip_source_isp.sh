#!/bin/bash

function GetGeoIP_DB() {
  wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz
  wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz
  wget http://download.maxmind.com/download/geoip/database/asnum/GeoIPASNum.dat.gz
  gunzip *.gz
  yes | mv *.dat /usr/share/GeoIP
}

if [ "`ls /usr/share/GeoIP/ | grep GeoIPASNum.dat`" == "" ] ; then
  GetGeoIP_DB
fi
Timestemp=`date -d '1 minute ago' '+%d/%b/%Y:%H:%M'`
LogFiles=`ls /opt/logs/nginx/*.access.log`

for Logs in $LogFiles
do
  SourceIP=`cat $Logs | grep $Timestemp | awk '{print $3}' | awk 'BEGIN {FS="="}{print $2}'`
    for IP in $SourceIP
      do
        geoiplookup -f /usr/share/GeoIP/GeoIPASNum.dat $IP | awk 'BEGIN {FS=":"}{print $2}' >> list
      done
    done
cat list | awk '{print $2" "$3" "$4 }' | sort | uniq -c
