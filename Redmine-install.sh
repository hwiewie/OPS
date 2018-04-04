#!/bin/sh
#讀取CentOS版本
release=`cat /etc/redhat-release | awk -F "release" '{print $2}' |awk -F "." '{print $1}' |sed 's/ //g'`
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
#新增Mariadb資源庫
echo "[mariadb]" >> /etc/yum.repos.d/MariaDB.repo
echo "name = MariaDB" >> /etc/yum.repos.d/MariaDB.repo
echo "baseurl = http://yum.mariadb.org/10.2/centos7-amd64" >> /etc/yum.repos.d/MariaDB.repo
echo "gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB" >> /etc/yum.repos.d/MariaDB.repo
echo "gpgcheck=1" >> /etc/yum.repos.d/MariaDB.repo
#安裝epel資源庫
yum -y install epel-release
#更新系統
yum -y update
#安裝常用套件
yum -y install yum-utils telnet bind-utils net-tools wget nc nmap perl perl-core gcc bzip2 git libxml2-devel libcurl-devel httpd-devel apr-devel apr-util-devel
#安裝LAMP
yum -y install httpd mariadb-server
yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum-config-manager --enable remi-php72
yum --enablerepo=remi,remi-php72 -y install php php-common php-cli php-pdo php-mysql php-gd php-mbstring php-mcrypt php-xml php-ldap php-snmp php-opcache php-imap php-xmlrpc php-pecl-apcu php-soap php-pecl-zip
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
#修改php設定參數
sed -i 's/max_execution_time = 30/max_execution_time = 600/g' /etc/php.ini
sed -i 's/max_input_time = 60/max_input_time = 300/g' /etc/php.ini
sed -i 's/memory_limit = 128M/memory_limit = 256M/g' /etc/php.ini
sed -i 's/post_max_size = 8M/post_max_size = 32M/g' /etc/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 16M/g' /etc/php.ini
sed -i 's/;date.timezone =/date.timezone = Asia\/Taipei/g' /etc/php.ini
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php.ini
#新增虛擬站台
echo "RailsEnv production" > /etc/httpd/conf.d/redmine.conf
echo "RailsBaseURI /redmine" >> /etc/httpd/conf.d/redmine.conf
echo "" >> /etc/httpd/conf.d/redmine.conf
echo "<Directory /home/redmine/redmine-3.4.4/public>" >> /etc/httpd/conf.d/redmine.conf
echo "Options FollowSymlinks" >> /etc/httpd/conf.d/redmine.conf
echo "AllowOverride none" >> /etc/httpd/conf.d/redmine.conf
echo "Require all granted" >> /etc/httpd/conf.d/redmine.conf
echo "</Directory>" >> /etc/httpd/conf.d/redmine.conf
#啟動apache
systemctl start httpd
#設定開機啟動apache
systemctl enable httpd
#安裝rvm
#install key
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
#Install RVM
\curl -sSL https://get.rvm.io | bash -s stable
source /etc/profile.d/rvm.sh
rvm requirements
rvm install ruby 2.2.10
#rvm install rubygem #gem install rails --no-rdoc --no-ri
#yum install -y ruby ruby-devel
gem install bundler
gem install rake --no-document
gem i nokogiri --no-document -v='1.6.8'
gem i mime-types --no-document
gem install rails --no-document -v='4.2.10'
gem install rbpdf --no-document
gem install rbpdf-font --no-document
gem install passenger
#安裝apache2-module
passenger-install-apache2-module
