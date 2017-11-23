#!/bin/bash
#從vhost目錄內，讀取所有conf，判斷是否有設定憑證
#如果有，就會列出那些域名是憑證內有但尚未綁定，
#及那些綁上去的域名是不在憑證內的
nginxconf=/opt/APP/openresty/nginx/conf/vhost/*.conf
if [[ -n $nginxconf ]];then
    echo "有vhost conf"
    #echo $nginxconf
else
    echo "找不到vhost conf"
    #echo $nginxconf
    exit
fi
#把所有vhost下的conf都找看看有沒有綁憑證
for filepathe in $nginxconf; do
    #取所有的憑證檔案路徑
    crtpath=`grep '^[ \s\t]*ssl_certificate\ .*crt' $filepathe | awk '{print $2}' | sed 's/;//'`
    if [[ -n $crtpath ]];then
        echo "有找到憑證"
        echo "憑證路徑：$crtpath"
        openssl x509 -in $crtpath -noout -text -certopt no_header,no_version,no_serial,no_signame,no_pubkey,no_sigdump,no_aux | grep -A1 "Subject Alternative Name:" | tail -n1 | tr -d ' ' | tr ',' '\n' | sed 's/DNS://g' > crtdomains.txt
        grep $'^[ \s\t]*server_name[ \s\t]*[0-9A-Za-z]*\.[0-9A-Za-z]*' $filepathe | sed -r 's/(.*server_name\s*|;)//g' | sed 's/\ /\n/g' | uniq > confdomains.txt
        echo "下面為憑證內有但conf內沒綁定的域名"
        sort crtdomains.txt confdomains.txt confdomains.txt | uniq -u
        echo "下面為憑證內沒有但conf內有綁定的域名"
        sort confdomains.txt crtdomains.txt crtdomains.txt | uniq -u
        rm -rf confdomains.txt
        rm -rf crtdomains.txt
        echo "結束"
    else
        echo "沒找到憑證"
        exit
    fi
done
