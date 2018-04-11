#!/bin/sh
#讀取CentOS版本
release=\`cat /etc/redhat-release | awk -F "release" '{print $2}' |awk -F "." '{print $1}' |sed 's/ //g'\`
#關閉SElinux
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
#設定網路校時
sed -i 's/server 0.centos.pool.ntp.org iburst/server tock.stdtime.gov.tw iburst/g' /etc/chrony.conf
sed -i 's/server 1.centos.pool.ntp.org iburst/server watch.stdtime.gov.tw iburst/g' /etc/chrony.conf
sed -i 's/server 2.centos.pool.ntp.org iburst/server tick.stdtime.gov.tw iburst/g' /etc/chrony.conf
sed -i 's/server 3.centos.pool.ntp.org iburst/server clock.stdtime.gov.tw iburst/g' /etc/chrony.conf
sed -i '/watch.stdtime.gov.tw/a server time.stdtime.gov.tw iburst' /etc/chrony.conf
systemctl restart chronyd
chronyc -a makestep
#防火牆設定
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --permanent --add-service=snmp
firewall-cmd --permanent --add-service=snmptrap
firewall-cmd --permanent --add-port=3306/tcp
firewall-cmd --permanent --add-port=5432/tcp
firewall-cmd --permanent --add-port=9000/tcp
firewall-cmd --permanent --add-port=10050/tcp
firewall-cmd --permanent --add-port=10051/tcp
firewall-cmd --add-port=3000/tcp --permanent
firewall-cmd --reload
#新增nginx知識庫
echo "[nginx]" >> /etc/yum.repos.d/nginx.repo
echo "name=nginx repo" >> /etc/yum.repos.d/nginx.repo
echo 'baseurl=http://nginx.org/packages/centos/7/$basearch/' >> /etc/yum.repos.d/nginx.repo
echo "gpgcheck=0" >> /etc/yum.repos.d/nginx.repo
echo "enabled=1" >> /etc/yum.repos.d/nginx.repo
#新增mariadb知識庫
echo "[mariadb]" >> /etc/yum.repos.d/MariaDB.repo
echo "name = MariaDB" >> /etc/yum.repos.d/MariaDB.repo
echo "baseurl = http://yum.mariadb.org/10.2/centos7-amd64" >> /etc/yum.repos.d/MariaDB.repo
echo "gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB" >> /etc/yum.repos.d/MariaDB.repo
echo "gpgcheck=1" >> /etc/yum.repos.d/MariaDB.repo
#安裝Grafana資源庫
echo "[grafana]" > /etc/yum.repos.d/grafana.repo
echo "name=grafana" >> /etc/yum.repos.d/grafana.repo
echo 'baseurl=https://packagecloud.io/grafana/stable/packages/el/7/$basearch' >> /etc/yum.repos.d/grafana.repo
echo "repo_gpgcheck=1" >> /etc/yum.repos.d/grafana.repo
echo "enabled=1" >> /etc/yum.repos.d/grafana.repo
echo "gpgcheck=1" >> /etc/yum.repos.d/grafana.repo
echo "gpgkey=https://packagecloud.io/gpg.key https://grafanarel.s3.amazonaws.com/RPM-GPG-KEY-grafana" >> /etc/yum.repos.d/grafana.repo
echo "sslverify=1" >> /etc/yum.repos.d/grafana.repo
echo "sslcacert=/etc/pki/tls/certs/ca-bundle.crt" >> /etc/yum.repos.d/grafana.repo
#安裝epel資源庫
yum -y install epel-release
#更新系統
yum -y update
#安裝常用套件
yum -y install yum-utils telnet bind-utils net-tools wget nc perl
#安裝postgreSQL10.2知識庫
yum install https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/pgdg-centos10-10-2.noarch.rpm
#安裝Zabbix3.4.2資源庫
yum install http://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm
#安裝PHP7.2知識庫
yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum-config-manager --enable remi-php72
#安裝nginx、postgresql 10、php7.2
yum -y install nginx postgresql10-server postgresql10 zabbix-server-pgsql zabbix-web-pgsql php72 php72-php-fpm php72-php-gd php72-php-json php72-php-mbstring php72-php-mysqlnd php72-php-xml php72-php-xmlrpc php72-php-pecl-mcrypt php72-php-bcmath php72-php-opcache php72-php-pgsql php72-php-ldap php72-php-pear php72-php-snmp
#打開PHP fpm for nginx
systemctl enable php72-php-fpm.service
systemctl start php72-php-fpm.service
#設定連結php72到php上
scl enable php72 bash
#修改php參數
sed -i 's/max\_execution\_time = 30/max\_execution\_time = 300/g' /etc/php.ini
sed -i 's/max\_input\_time = 60/max\_input\_time = 300/g' /etc/php.ini
sed -i 's/memory\_limit = 128M/memory\_limit = 256M/g' /etc/php.ini
sed -i 's/post\_max\_size = 8M/post\_max\_size = 32M/g' /etc/php.ini
sed -i 's/upload\_max\_filesize = 2M/upload\_max\_filesize = 16M/g' /etc/php.ini
sed -i 's/;date.timezone =/date.timezone = Asia\\/Taipei/g' /etc/php.ini
sed -i 's/;cgi.fix\_pathinfo=1/cgi.fix\_pathinfo=0/g' /etc/php.ini
#修改nginx設定
sed -i 's/worker\_processes  1/worker\_processes  4/g' /etc/nginx/nginx.conf
sed -i 's/worker\_connections  1024/worker\_connections  10240/g' /etc/nginx/nginx.conf
sed -i 's/#tcp\_nopush/tcp\_nopush/g' /etc/nginx/nginx.conf
sed -i '/tcp\_nopush/a    tcp\_nodelay    on;' /etc/nginx/nginx.conf
sed -i 's/keepalive\_timeout  65/keepalive\_timeout  120/g' /etc/nginx/nginx.conf
sed -i '/gzip/a    fastcgi\_read\_timeout 300;' /etc/nginx/nginx.conf
sed -i '/gzip/a    fastcgi\_send\_timeout 300;' /etc/nginx/nginx.conf
sed -i '/gzip/a    fastcgi\_connect\_timeout 300;' /etc/nginx/nginx.conf
sed -i '/gzip/a    fastcgi\_temp\_file\_write\_size 128k;' /etc/nginx/nginx.conf
sed -i '/gzip/a    fastcgi\_busy\_buffers_size 128k;' /etc/nginx/nginx.conf
sed -i '/gzip/a    fastcgi_buffers 32 32k;' /etc/nginx/nginx.conf
sed -i '/gzip/a    fastcgi\_buffer\_size 128k;' /etc/nginx/nginx.conf
#啟動nginx
systemctl start nginx
systemctl enable nginx
#修改php-fpm內使用者設定
sed -i 's/user = apache/user = nginx/g' /etc/php-fpm.d/www.conf
sed -i 's/group = apache/group = nginx/g' /etc/php-fpm.d/www.conf
#啟動php-fpm
systemctl restart php-fpm
systemctl enable php-fpm
#修改postgresql設定
#修改Mariadb設定
echo "[mysqld]" > /etc/my.cnf
echo "innodb_file_per_table=1" >> /etc/my.cnf
echo "query_cache_limit=8M" >> /etc/my.cnf
echo "innodb_buffer_pool_size=2G" >> /etc/my.cnf
echo "performance_schema=OFF" >> /etc/my.cnf
echo "query_cache_type=1" >> /etc/my.cnf
echo "query_cache_min_res_unit=2k" >> /etc/my.cnf
echo "query_cache_size=80M" >> /etc/my.cnf
echo "tmp_table_size=64M" >> /etc/my.cnf
echo "max_heap_table_size=64M" >> /etc/my.cnf
echo "slow-query-log=1" >> /etc/my.cnf
echo "slow-query-log-file=/var/lib/mysql/mysql-slow.log" >> /etc/my.cnf
echo "long_query_time=1" >> /etc/my.cnf
echo "[client-server]" >> /etc/my.cnf
echo '!includedir /etc/my.cnf.d' >> /etc/my.cnf
#修改zabbix server 設定
sed -i '125aDBPassword="密碼"' /etc/zabbix/zabbix_server.conf
sed -i '339aStartSNMPTrapper=1' /etc/zabbix/zabbix_server.conf
#啟動zabbix server
systemctl start zabbix-server
#設定開機啟動zabbix-server
systemctl enable zabbix-server
#設定web目錄執行權限
chown nginx:nginx /etc/zabbix/web/
chown nginx:nginx -R /usr/share/zabbix
chown nginx /var/log/php-fpm
chown root:nginx /var/lib/php/session/
#寫入測試網頁(用httt://localhost/zabbix/info.php)
echo '<?php phpinfo(); ?>' > /usr/share/zabbix/info.php
#新增zabbix這個vhost在nginx設定目錄下
echo "server {" >> /etc/nginx/conf.d/zabbix.conf
echo "    listen       80;" >> /etc/nginx/conf.d/zabbix.conf
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
echo "            fastcgi\_buffer\_size 128k;" >> /etc/nginx/conf.d/zabbix.conf
echo "            fastcgi_buffers 32 32k;" >> /etc/nginx/conf.d/zabbix.conf
echo "            include                 /etc/nginx/fastcgi_params;" >> /etc/nginx/conf.d/zabbix.conf
echo "            fastcgi\_split\_path_info ^(.+\\.php)(/.+)$;" >> /etc/nginx/conf.d/zabbix.conf
echo "            fastcgi_index           index.php;" >> /etc/nginx/conf.d/zabbix.conf
echo "            fastcgi_pass           127.0.0.1:9000;" >> /etc/nginx/conf.d/zabbix.conf
echo '            fastcgi\_param SCRIPT\_FILENAME $request_filename;' >> /etc/nginx/conf.d/zabbix.conf
echo "         }" >> /etc/nginx/conf.d/zabbix.conf
echo "" >> /etc/nginx/conf.d/zabbix.conf
echo "         location ~ \\.(jpg|jpeg|gif|png|ico)$ {" >> /etc/nginx/conf.d/zabbix.conf
echo "             access_log      off;" >> /etc/nginx/conf.d/zabbix.conf
echo "             expires         33d;" >> /etc/nginx/conf.d/zabbix.conf
echo "         }" >> /etc/nginx/conf.d/zabbix.conf
echo "    }" >> /etc/nginx/conf.d/zabbix.conf
echo "}" >> /etc/nginx/conf.d/zabbix.conf

#安裝SNMP套件
yum install net-snmp* -y
sed -i '/.1.3.6.1.2.1.25.1.1/aview    systemview    included   .1' /etc/snmp/snmpd.conf
sed -i 's/#proc mountd/proc mountd/g' /etc/snmp/snmpd.conf
sed -i 's/#proc ntalkd 4/proc ntalkd 4/g' /etc/snmp/snmpd.conf
sed -i 's/#proc sendmail 10 1/proc sendmail 10 1/g' /etc/snmp/snmpd.conf
sed -i 's/#disk \\/ 10000/disk \\/ 10000/g' /etc/snmp/snmpd.conf
sed -i 's/#load 12 14 14/load 12 14 14/g' /etc/snmp/snmpd.conf
systemctl start snmpd
systemctl enable snmpd

#校能調校
sed -i '29azabbix hard nofile 10240' /etc/security/limits.conf
sed -i '29azabbix soft nofile 10240' /etc/security/limits.conf
sed -i '29anginx hard nofile 10240' /etc/security/limits.conf
sed -i '29anginx soft nofile 10240' /etc/security/limits.conf
sed -i '29amysql hard nofile 10240' /etc/security/limits.conf
sed -i '29amysql soft nofile 10240' /etc/security/limits.conf
systemctl daemon-reload

#安裝grafana
yum -y install grafana
#設定grafana
#啟動grafana
systemctl start grafana-server.service
systemctl enable grafana-server.service

#初始化資料庫
/usr/pgsql-10/bin/postgresql-10-setup initdb
#啟動資料庫
systemctl start postgresql-10.service
systemctl enable postgresql-10.service

#設定密碼
su - postgres -c "psql"
\password postgres
\q

#修改認証方式
vi /var/lib/pgsql/10/data/pg_hba.conf

#新增zabbix可以登入
local    zabbix          zabbix                                md5
host     zabbix          zabbix          127.0.0.1/32

#建立資料庫
su - postgres -c "psql"
create role zabbix login ;
\password zabbix
create database zabbix with template template0 encoding 'UTF8' ;
grant all on database zabbix to zabbix;
\q

#資料庫設定(Mariadb)
mysql_secure_installation
#建立資料庫
mysql -u root -p
create database zabbix character set utf8 collate utf8_bin ;
grant all privileges on zabbix.* to zabbix@localhost identified by "密碼";
flush privileges;
exit
#導入DB schema
cd /usr/share/doc/zabbix-server-mysql-3.4.7/ 
gunzip create.sql.gz 
mysql -u root -p zabbix < create.sql
