#!/bin/bash
resoult=`curl -w ',"response_code":"%{response_code}","header_size":"%{size_header}","request_size":"%{size_request}","download_size":"%{size_download}","upload_size":"%{size_upload}","download_speed":"%{speed_download}","upload_speed":"%{speed_upload}","num_connects":"%{num_connects}","num_redirects":"%{num_redirects}","remote_ip":"%{remote_ip}","time_namelookup":"%{time_namelookup}","time_appconnect":"%{time_appconnect}","time_connect":"%{time_connect}","time_redirect":"%{time_redirect}","time_pretransfer":"%{time_pretransfer}","time_starttransfer":"%{time_starttransfer}","time_total":"%{time_total}"}' -o gameboyping.txt -s "https://api3.cqgame.cc/gameboy/ping"`
sed -i 's/"status":{//g' gameboyping.txt
sed -i 's/}}//g' gameboyping.txt
echo $resoult >> gameboyping.txt
cat gameboyping.txt >> /var/log/gameboyapi.log
rm -rf gameboyping.txt
