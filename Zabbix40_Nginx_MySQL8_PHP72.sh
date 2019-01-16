#!/bin/sh
######################################################################
# 2019/01/16
######################################################################
#####################################################################
#程式開始
#####################################################################
#設定db密碼
dbpasswd=1234567
#讀取CentOS版本
release=`cat /etc/redhat-release | awk -F "release" '{print $2}' |awk -F "." '{print $1}' |sed 's/ //g'`
#讀取網卡IP
localip=`ifconfig | awk -F'[ :]+' '/broadcast/{print $3}'`
#關閉SElinux
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
#設定網路校時
sed -i 's/server 0.centos.pool.ntp.org iburst/server tock.stdtime.gov.tw iburst/g' /etc/chrony.conf
sed -i 's/server 1.centos.pool.ntp.org iburst/server watch.stdtime.gov.tw iburst/g' /etc/chrony.conf
sed -i 's/server 2.centos.pool.ntp.org iburst/server tick.stdtime.gov.tw iburst/g' /etc/chrony.conf
sed -i 's/server 3.centos.pool.ntp.org iburst/server clock.stdtime.gov.tw iburst/g' /etc/chrony.conf
sed -i '/watch.stdtime.gov.tw/a server time.stdtime.gov.tw iburst' /etc/chrony.conf
systemctl restart chronyd
chronyc -a makestep
#新增nginx知識庫
echo "[nginx]" >> /etc/yum.repos.d/nginx.repo
echo "name=nginx repo" >> /etc/yum.repos.d/nginx.repo
echo 'baseurl=http://nginx.org/packages/centos/7/$basearch/' >> /etc/yum.repos.d/nginx.repo
echo "gpgcheck=0" >> /etc/yum.repos.d/nginx.repo
echo "enabled=1" >> /etc/yum.repos.d/nginx.repo
#安裝Grafana資源庫
echo "[grafana]" > /etc/yum.repos.d/grafana.repo
echo "name=grafana" >> /etc/yum.repos.d/grafana.repo
echo 'baseurl=https://packagecloud.io/grafana/stable/el/7/$basearch' >> /etc/yum.repos.d/grafana.repo
echo "repo_gpgcheck=1" >> /etc/yum.repos.d/grafana.repo
echo "enabled=1" >> /etc/yum.repos.d/grafana.repo
echo "gpgcheck=1" >> /etc/yum.repos.d/grafana.repo
echo "gpgkey=https://packagecloud.io/gpg.key https://grafanarel.s3.amazonaws.com/RPM-GPG-KEY-grafana" >> /etc/yum.repos.d/grafana.repo
echo "sslverify=1" >> /etc/yum.repos.d/grafana.repo
echo "sslcacert=/etc/pki/tls/certs/ca-bundle.crt" >> /etc/yum.repos.d/grafana.repo
#安裝epel資源庫
yum -y install epel-release
#安裝MySQL8知識庫
yum localinstall https://dev.mysql.com/get/mysql80-community-release-el7-1.noarch.rpm
#安裝PHP7.x知識庫
yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
#安裝Zabbix4.0資源庫
rpm -i https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-1.el7.noarch.rpm
#更新系統
yum -y update
#安裝常用套件
yum -y install yum-utils telnet bind-utils net-tools wget nc nmap perl perl-core gcc bzip2 git net-snmp* libcurl-devel
#設定啟用remi(安裝php7.2)
yum-config-manager --enable remi-php72
#安裝nginx、MySQL8、php7.2
yum -y install nginx mysql-community-server zabbix-server-mysql zabbix-web-mysql zabbix-agent
yum --enablerepo=remi,remi-php72 -y install php php-common php-cli php-pdo php-fpm php-pgsql php-gd php-mbstring php-mcrypt php-xml php-ldap php-snmp php-opcache php-imap php-xmlrpc php-pecl-apcu php-soap php-pecl-zip
#修改php設定參數
sed -i 's/max_execution_time = 30/max_execution_time = 600/g' /etc/php.ini
sed -i 's/max_input_time = 60/max_input_time = 300/g' /etc/php.ini
sed -i 's/memory_limit = 128M/memory_limit = 256M/g' /etc/php.ini
sed -i 's/post_max_size = 8M/post_max_size = 32M/g' /etc/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 16M/g' /etc/php.ini
sed -i 's/;date.timezone =/date.timezone = Asia\/Taipei/g' /etc/php.ini
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php.ini
#修改nginx設定
sed -i 's/worker_connections  1024/worker_connections  10240/g' /etc/nginx/nginx.conf
sed -i 's/#tcp_nopush/tcp_nopush/g' /etc/nginx/nginx.conf
sed -i 's/keepalive_timeout   65/keepalive_timeout   120/g' /etc/nginx/nginx.conf
sed -i '/types_hash_max_size/a    fastcgi_read_timeout 300;' /etc/nginx/nginx.conf
sed -i '/types_hash_max_size/a    fastcgi_send_timeout 300;' /etc/nginx/nginx.conf
sed -i '/types_hash_max_size/a    fastcgi_connect_timeout 300;' /etc/nginx/nginx.conf
sed -i '/types_hash_max_size/a    fastcgi_temp_file_write_size 128k;' /etc/nginx/nginx.conf
sed -i '/types_hash_max_size/a    fastcgi_busy_buffers_size 128k;' /etc/nginx/nginx.conf
sed -i '/types_hash_max_size/a    fastcgi_buffers 32 32k;' /etc/nginx/nginx.conf
sed -i '/types_hash_max_size/a    fastcgi_buffer_size 128k;' /etc/nginx/nginx.conf
sed -i '/types_hash_max_size/a    client_max_body_size 8m;' /etc/nginx/nginx.conf
#新增虛擬站台設定
echo "server {" > /etc/nginx/conf.d/zabbix.conf
echo "    listen       80;" >> /etc/nginx/conf.d/zabbix.conf
echo "    server_name  $localip;" >> /etc/nginx/conf.d/zabbix.conf
echo "    index index.html index.php;" >> /etc/nginx/conf.d/zabbix.conf
echo "    root /usr/share/zabbix;" >> /etc/nginx/conf.d/zabbix.conf
echo ""  >> /etc/nginx/conf.d/zabbix.conf
echo "    location /zabbix {" >> /etc/nginx/conf.d/zabbix.conf
echo "        alias                       /usr/share/zabbix/;" >> /etc/nginx/conf.d/zabbix.conf
echo "        index                       index.php;" >> /etc/nginx/conf.d/zabbix.conf
echo "        error_page          403 404 502 503 504  /zabbix/index.php;" >> /etc/nginx/conf.d/zabbix.conf
echo "        location ~ \\.php$ {" >> /etc/nginx/conf.d/zabbix.conf
echo '            if (!-f $request_filename) { return 404; }' >> /etc/nginx/conf.d/zabbix.conf
echo "            expires                 epoch;" >> /etc/nginx/conf.d/zabbix.conf
echo "            fastcgi_buffer_size 128k;" >> /etc/nginx/conf.d/zabbix.conf
echo "            fastcgi_buffers 32 32k;" >> /etc/nginx/conf.d/zabbix.conf
echo "            include                 /etc/nginx/fastcgi_params;" >> /etc/nginx/conf.d/zabbix.conf
echo "            fastcgi_split_path_info ^(.+\\.php)(/.+)$;" >> /etc/nginx/conf.d/zabbix.conf
echo "            fastcgi_index           index.php;" >> /etc/nginx/conf.d/zabbix.conf
echo "            fastcgi_pass           127.0.0.1:9000;" >> /etc/nginx/conf.d/zabbix.conf
echo '            fastcgi_param SCRIPT_FILENAME $request_filename;' >> /etc/nginx/conf.d/zabbix.conf
echo "         }" >> /etc/nginx/conf.d/zabbix.conf
echo "" >> /etc/nginx/conf.d/zabbix.conf
echo "         location ~ \\.(jpg|jpeg|gif|png|ico)$ {" >> /etc/nginx/conf.d/zabbix.conf
echo "             access_log      off;" >> /etc/nginx/conf.d/zabbix.conf
echo "             expires         33d;" >> /etc/nginx/conf.d/zabbix.conf
echo "         }" >> /etc/nginx/conf.d/zabbix.conf
echo "    }" >> /etc/nginx/conf.d/zabbix.conf
echo "}" >> /etc/nginx/conf.d/zabbix.conf
#啟動nginx
systemctl start nginx
systemctl enable nginx
#修改php-fpm內使用者設定
sed -i 's/user = apache/user = nginx/g' /etc/php-fpm.d/www.conf
sed -i 's/group = apache/group = nginx/g' /etc/php-fpm.d/www.conf
#啟動php-fpm
systemctl restart php-fpm
systemctl enable php-fpm
#寫入測試網頁(用httt://localhost/zabbix/info.php)
echo '<?php phpinfo(); ?>' > /usr/share/zabbix/info.php
#初始化資料庫

#修改MySQL設定

#啟動MySQL
systemctl start mysqld
systemctl enable mysqld
#設定防火牆
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --permanent --add-service=mysql
firewall-cmd --permanent --new-service=zabbix
firewall-cmd --permanent --service=graylog --set-short="Zabbix Service Ports"
firewall-cmd --permanent --service=graylog --set-description="Zabbix service firewalld port exceptions"
firewall-cmd --permanent --service=graylog --add-port=3000/tcp
firewall-cmd --permanent --service=graylog --add-port=10050/tcp
firewall-cmd --permanent --service=graylog --add-port=10051/tcp
firewall-cmd --permanent --add-service=zabbix
firewall-cmd --reload
#設定web目錄執行權限
chown nginx:nginx /etc/zabbix/web/
chown nginx:nginx -R /usr/share/zabbix
chown nginx /var/log/php-fpm
chown root:nginx /var/lib/php/session/
#修改zabbix server 設定
sed -i '/# DBHost=localhost/aDBHost=' /etc/zabbix/zabbix_server.conf
sed -i '/DBPassword=/aDBPassword=$dbpasswd' /etc/zabbix/zabbix_server.conf
sed -i '/# StartSNMPTrapper=0/aStartSNMPTrapper=1' /etc/zabbix/zabbix_server.conf
#啟動zabbix server
systemctl start zabbix-server
#設定開機啟動zabbix-server
systemctl enable zabbix-server
#安裝SNMP套件
sed -i '/.1.3.6.1.2.1.25.1.1/aview    systemview    included   .1' /etc/snmp/snmpd.conf
sed -i 's/#proc mountd/proc mountd/g' /etc/snmp/snmpd.conf
sed -i 's/#proc ntalkd 4/proc ntalkd 4/g' /etc/snmp/snmpd.conf
sed -i 's/#proc sendmail 10 1/proc sendmail 10 1/g' /etc/snmp/snmpd.conf
sed -i 's/#disk \/ 10000/disk \/ 10000/g' /etc/snmp/snmpd.conf
sed -i 's/#load 12 14 14/load 12 14 14/g' /etc/snmp/snmpd.conf
systemctl start snmpd
systemctl enable snmpd
#校能調校
sed -i '29azabbix hard nofile 10240' /etc/security/limits.conf
sed -i '29azabbix soft nofile 10240' /etc/security/limits.conf
sed -i '29anginx hard nofile 10240' /etc/security/limits.conf
sed -i '29anginx soft nofile 10240' /etc/security/limits.conf
sed -i '29apostgres hard nofile 10240' /etc/security/limits.conf
sed -i '29apostgres soft nofile 10240' /etc/security/limits.conf
systemctl daemon-reload
#除錯
sed -i '/$last = strtolower(substr($val, -1));/a$val = substr($val,0,-1);' /usr/share/zabbix/include/func.inc.php
sed -i 's/7.0/7.4/g' /usr/share/zabbix/include/classes/setup/CFrontendSetup.php
#安裝grafana
yum -y install grafana
#設定grafana
chown -R grafana:grafana /var/lib/grafana
#安裝插件
grafana-cli plugins install alexanderzobnin-zabbix-app
#啟動grafana
systemctl start grafana-server.service
systemctl enable grafana-server.service
