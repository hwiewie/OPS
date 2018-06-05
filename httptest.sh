#!/bin/bash
#程式說明：用來統計網頁的效能資料
#用法：./httptest.sh 參數一
#參數一：要測試的網址
#數值結果說明：
#response_code=網頁回傳狀態
#header_size=接收到header的bytes
#request_size=發出的http請求中傳送的bytes
#download_size=已下載的bytes
#upload_size=已上傳的bytes
#download_speed=平均下載速度
#upload_speed=平均上傳速度
#num_connects=新成功連接數
#num_redirects=新成功重新定向數
#remote_ip=網頁伺服器的IP
#time_namelookup=從開始到名稱解析完成的時間
#time_appconnect=從開始到SSL / SSH握手完成的時間
#time_connect=從開始到遠程主機或代理完成的時間
#time_redirect=在最終傳輸之前所有重定向步驟花費的時間
#time_pretransfer=從開始到轉移開始之前的時間
#time_starttransfer=從開始到收到第一個byte的時間
#time_total=傳輸的總時間
curl -w '\nresponse_code=%{response_code}\nheader_size=%{size_header}\nrequest_size=%{size_request}\ndownload_size=%{size_download}\nupload_size=%{size_upload}\ndownload_speed=%{speed_download}\nupload_speed=%{speed_upload}\nnum_connects=%{num_connects}\nnum_redirects=%{num_redirects}\nremote_ip=%{remote_ip}\ntime_namelookup=%{time_namelookup}\ntime_appconnect=%{time_appconnect}\ntime_connect=%{time_connect}\ntime_redirect=%{time_redirect}\ntime_pretransfer=%{time_pretransfer}\ntime_starttransfer=%{time_starttransfer}\ntime_total=%{time_total}\n\n' -o /dev/null -s "$1"
