#!/bin/bash
#程式說明：用來統計網頁的效能資料
#用法：./webpagetest.sh 參數一
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
#10
#迪拜前台
dubaif[1]=www.599499.com
#dubaif[2]=www.dubaib79bet.com
dubaif[3]=www.5282288.com
dubaif[4]=https://486486.com/
dubaif[5]=www.99thang.com
dubaif[6]=www.999thang.com
dubaif[7]=www.db3377.com
dubaif[8]=www.db79bet.com
dubaif[9]=www.1232233.com
#dubaif[10]=dubaibc588.com
dubaif[11]=db7822.com
#dubaif[12]=dubaib699.com
dubaif[13]=dp6888.com
dubaif[14]=dp6888.com
dubaif[15]=wynn5.com
#dubaif[16]=dubaib486.com
dubaif[17]=https://486486.com/
#迪拜後台
dubaib[1]=ctl.1232233.com
#dubaib[2]=ctl.dubaib6868.com
dubaib[3]=ctl.5282288.com
dubaib[4]=ctl.599499.com
dubaib[5]=ctl.db699.com
dubaib[6]=https://ctl.399699.com/
#dubaib[7]=
#dubaib[8]=
#dubaib[9]=
#dubaib[10]=
#必博前台
#bibetf[1]=bibet5.com
#bibetf[2]=bibet6.com
#bibetf[3]=bibet7.com
#bibetf[4]=bibet8.com
#bibetf[5]=bibet9.com
#必博後台
#bibetb[1]=ctl.bibet5.com
#bibetb[2]=ctl.bibet6.com
#bibetb[3]=ctl.bibet7.com
#bibetb[4]=ctl.bibet8.com
#bibetb[5]=ctl.bibet9.com
#188金寶博前台
bet188f[1]=https://188188bet.cc/
bet188f[2]=wp1988.com
bet188f[3]=wp5533.com
bet188f[4]=1788wp.com
#188金寶博後台
bet188b[1]=ctl.188188bet.cc
#賽博前台
saibetf[1]=www.sbets.net
#saibetf[2]=
#saibetf[3]=
#saibetf[4]=
#賽博後台
#saibetb[1]=ctl.581bet.com
#saibetb[2]=ctl.582bet.com
#saibetb[3]=ctl.641541.com
#saibetb[4]=ctl.sssball.com
#MONOCO前台
monocof[1]=www.mnc80.com
monocof[2]=www.mnc90.com
#MONOCO後台
monocob[1]=ctl.mnc80.com
#518導航網
#518前台
wu18f[1]=https://188522.com/
wu18f[2]=
wu18f[3]=tin518.com
wu18f[4]=518ikm.com
wu18f[5]=au566.com
wu18f[6]=https://kza588.com/
wu18f[7]=https://jkz128.com/
wu18f[8]=518azx.com
wu18f[9]=https://wan5188.com/
wu18f[10]=https://518facai.com/
wu18f[11]=https://mcw518.com/
wu18f[12]=www.776772.com
wu18f[13]=www.518111.info
wu18f[14]=www.518222.info
wu18f[15]=tab568.com
wu18f[16]=www.518363.com
#518後台
wu18b[1]=https://ctl.kza588.com/
wu18b[2]=https://ctl.jkz128.com/
wu18b[3]=ctl.8468466.com
wu18b[4]=https://ctl.188522.com/
wu18b[5]=ctl.118518.com
wu18b[6]=ctl.tin518.com
wu18b[7]=ctl.518ikm.com
wu18b[8]=ctl.au566.com
wu18b[9]=ctl.188922.com
#wu18b[10]=
#wu18b[11]=
#wu18b[12]=
#wu18b[13]=
#899前台
ba99f[1]=https://3838389.com/
ba99f[2]=https://998948.com/
ba99f[3]=https://899200.cc/
ba99f[4]=https://899300.cc/
ba99f[5]=https://899500.cc/
ba99f[6]=https://899700.cc/
#ba99f[7]=
#899後台
ba99b[1]=https://ctl.899200.cc/
ba99b[2]=https://ctl.899300.cc/
ba99b[3]=https://ctl.899500.cc/
ba99b[4]=https://ctl.899700.cc/
#ba99b[5]=
#82前台
ba2f[1]=https://828282.com/
ba2f[2]=https://8282100.com/
ba2f[3]=https://8282200.com/
#ba2f[4]=
#82後台
ba2b[1]=https://ctl.828282.com/
#金沙會
jshf[1]=https://87080.com/
#優博前台
youbof[1]=7996.com
#優博後台
youbob[1]=https://u1688.ubpop.com/
#金贊前台
jinzanf[1]=www.365playjz.com
#金贊後台
jinzanb[1]=https://jz168.1591599.com
#威尼斯人前台
venetianf[1]=www.518333.info
venetianf[2]=https://www.vn9687.com
venetianf[3]=vn9886.com
#澳門銀河
macaugalaxyf[1]=www.yh777c.com
macaugalaxyf[2]=www.yh32123.com
#新豪天地
cityofdreamsf[1]=www.xh833.com
#澳門新葡京酒店
grandlisboahf[1]=www.xp336.com
#澳門皇冠
crowntowersf[1]=www.hg486486.com
crowntowersf[2]=www.zx518.tk
crowntowersf[3]=833733.com
crowntowersf[4]=125785.info
crowntowersf[5]=www.3773777.net
#太陽城
suncitygroupf[1]=www.ty383.com
suncitygroupf[2]=552556.com
#永利皇宮
wynnpalacecotaif[1]=www.922322.com
wynnpalacecotaif[2]=www.yl9633.com
#金沙會
sanoscasinof[1]=www.933533.com
sanoscasinof[2]=www.js36993.com
#美高梅
mgmf[1]=www.322522.com
mgmf[2]=www.mg3233.com
#星際
xjf[1]=www.393893.com
xjf[2]=www.xj3883.com
#集美(原星河)
jimeicasinof[1]=www.xh52888.com
#明陞88
#澳門新葡京
grandlisboaf[1]=www.888346.com
grandlisboaf[2]=www.68588.cc
#澳門巴黎人
parisianf[1]=www.pl966.com
parisianf[2]=575799.com
#後台
itwinstarb[1]=ctl.sitemulti.com

function getinfo(){
  valu=$(eval echo "\${$1[@]}")
  #echo $valu
  for item in $valu; do
    exctime=`date '+%Y-%m-%d %H:%M:%S'`
    httptest $item
    echo ',"time": "'$exctime'","url": "'$item'"}' >> /var/log/httptest.log
  done
}

function httptest(){
  curl --connect-timeout 5 -m 10 -w '{"response_code": "%{response_code}","header_size": %{size_header},"request_size": %{size_request},"download_size": %{size_download},"upload_size": %{size_upload},"download_speed": %{speed_download},"upload_speed": %{speed_upload},"num_connects": %{num_connects},"num_redirects": %{num_redirects},"remote_ip": "%{remote_ip}","time_namelookup": %{time_namelookup},"time_appconnect": %{time_appconnect},"time_connect": %{time_connect},"time_redirect": %{time_redirect},"time_pretransfer": %{time_pretransfer},"time_starttransfer": %{time_starttransfer},"time_total": %{time_total}' -o /dev/null -s "$item" >> /var/log/httptest.log
}
function helps(){
  echo "使用語法說明："
  echo "使用語法(一)：sh domain_test.sh 域名"
  echo "測試該網域的連線資料"
  echo "使用語法(二)：sh domain_test.sh 品牌平台 域名"
  echo "品牌平台代碼："
  echo "迪拜前台：dubaif，迪拜後台：dubaib，必博前台：bibetf，必博後台：bibetb"
  echo "188金寶博前台：bet188f，188金寶博後台：bet188b，賽博前台：saibetf，賽博後台：saibetb"
  echo "MONOCO前台：monocof，MONOCO後台：monocob，518前台：wu18f，518後台：wu18b"
  echo "899前台：ba99f，899後台：ba99b，82前台：ba2f，82後台：ba2b"
}
#判斷參數
if [ $# -eq "0" ];then
  echo "參數錯誤："
  helps
#  exit
fi
#debet_f
regex='^\w+\.+\w'
case "$1" in
"dubaif"|"dubaib"|"bibetf"|"bibetb"|"bet188f"|"bet188b"|"saibetf"|"saibetb"|"monocof"|"saibetb"|"monocof"|"monocob"|"wu18f"|"wu18b"|"ba99f"|"ba99b"|"ba2f"|"ba2b")
  getinfo $1
  ;;
"all")
  getinfo "dubaif"
  getinfo "dubaib"
  getinfo "bibetf"
  getinfo "bibetb"
  getinfo "bet188f"
  getinfo "bet188b"
  getinfo "saibetf"
  getinfo "saibetb"
  getinfo "monocof"
  getinfo "saibetb"
  getinfo "monocof"
  getinfo "monocob"
  getinfo "wu18f"
  getinfo "wu18b"
  getinfo "ba99f"
  getinfo "ba99b"
  getinfo "ba2f"
  getinfo "ba2b"
  getinfo "jshf"
  getinfo "youbof"
  getinfo "youbob"
  getinfo "jinzanf"
  getinfo "jinzanb"
  getinfo "venetianf"
  getinfo "macaugalaxyf"
  getinfo "cityofdreamsf"
  getinfo "grandlisboahf"
  getinfo "crowntowersf"
  getinfo "suncitygroupf"
  getinfo "wynnpalacecotaif"
  getinfo "sanoscasinof"
  getinfo "mgmf"
  getinfo "xjf"
  getinfo "jimeicasinof"
  getinfo "grandlisboaf"
  getinfo "parisianf"
  getinfo "itwinstarb"
  ;;
*)
  helps
  ;;
esac
