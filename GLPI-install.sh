#!/bin/sh
#系統需求：apache 2.4、mariadb 10、php 7.2.4
#讀取CentOS版本
release=`cat /etc/redhat-release | awk -F "release" '{print $2}' |awk -F "." '{print $1}' |sed 's/ //g'`
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
#新增mariadb知識庫
echo "[mariadb]" >> /etc/yum.repos.d/MariaDB.repo
echo "name = MariaDB" >> /etc/yum.repos.d/MariaDB.repo
echo "baseurl = http://yum.mariadb.org/10.2/centos7-amd64" >> /etc/yum.repos.d/MariaDB.repo
echo "gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB" >> /etc/yum.repos.d/MariaDB.repo
echo "gpgcheck=1" >> /etc/yum.repos.d/MariaDB.repo
#新增nginx知識庫
echo "[nginx]" >> /etc/yum.repos.d/nginx.repo
echo "name=nginx repo" >> /etc/yum.repos.d/nginx.repo
echo 'baseurl=http://nginx.org/packages/centos/7/$basearch/' >> /etc/yum.repos.d/nginx.repo
echo "gpgcheck=0" >> /etc/yum.repos.d/nginx.repo
echo "enabled=1" >> /etc/yum.repos.d/nginx.repo
#安裝epel資源庫
yum -y install epel-release
#更新系統
yum -y update
#安裝常用套件
yum -y install yum-utils telnet bind-utils net-tools wget nc nmap perl gcc perl-core
#安裝postgresql資源庫
yum install https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/pgdg-centos10-10-2.noarch.rpm
#安裝必要套件
yum -y httpd mariadb-server
#設定apache

#設定mariadb
sed -i '4along_query_time=1' /etc/my.cnf
sed -i '4aslow-query-log-file=/var/lib/mysql/mysql-slow.log' /etc/my.cnf
sed -i '4aslow-query-log=1' /etc/my.cnf
sed -i '4amax_heap_table_size=64M' /etc/my.cnf
sed -i '4atmp_table_size=64M' /etc/my.cnf
sed -i '4aquery_cache_size=80M' /etc/my.cnf
sed -i '4aquery_cache_min_res_unit=2k' /etc/my.cnf
sed -i '4aquery_cache_type=1' /etc/my.cnf
sed -i '4aperformance_schema=OFF' /etc/my.cnf
sed -i '4ainnodb_buffer_pool_size=2G' /etc/my.cnf
sed -i '4aquery_cache_limit=8M' /etc/my.cnf
sed -i '4ainnodb_file_per_table=1' /etc/my.cnf
sed -i '4a[mysqld]' /etc/my.cnf
#啟動mariadb
systemctl start mariadb
#設定開機啟動
systemctl enable mariadb
#安裝PHP7.2知識庫
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
#安裝php7.2
yum --enablerepo=remi,remi-php72 -y install php php-common php-cli php-pdo php-mysql php-gd php-mbstring php-mcrypt php-xml php-ldap php-snmp php-opcache php-imap php-xmlrpc php-pecl-apcu php-soap php-pecl-zip
#修改php設定參數
sed -i 's/max_execution_time = 30/max_execution_time = 600/g' /etc/php.ini
sed -i 's/max_input_time = 60/max_input_time = 300/g' /etc/php.ini
sed -i 's/memory_limit = 128M/memory_limit = 256M/g' /etc/php.ini
sed -i 's/post_max_size = 8M/post_max_size = 32M/g' /etc/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 16M/g' /etc/php.ini
sed -i 's/;date.timezone =/date.timezone = Asia\/Taipei/g' /etc/php.ini
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php.ini
#安裝其他套件
yum -y install openssl-devel jansson-devel libev-devel c-ares-devel
#修改selinux設定(為了安裝不要出現告警)
setsebool -P httpd_can_network_connect 1

#防火牆設定
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --reload
#下載GLPI
wget https://github.com/glpi-project/glpi/releases/download/9.2.2/glpi-9.2.2.tgz
tar -zxvf glpi-9.2.2.tgz
mv glpi/ /var/www/html/
chown -R apache:apache /var/www/html
