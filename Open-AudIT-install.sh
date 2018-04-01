#!/bin/sh
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
#安裝epel資源庫
yum -y install epel-release
#更新系統
yum -y update
#安裝常用套件
yum -y install yum-utils telnet bind-utils net-tools wget nc nmap perl gcc bzip2 git
#安裝必要套件
yum install -y perl-core httpd postgresql10-server postgresql10
 zip sshpass screen samba-client perl-Time-modules ipmitool rrdtool libpng12
#安裝PHP7.2知識庫
yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
#安裝php7.2( php-mysqlnd 先不裝)
yum --enablerepo=remi,remi-php72 -y install php php-common php-cli php-pdo php-pgsql php-gd php-mbstring php-mcrypt php-xml php-ldap php-snmp php-opcache php-imap
#修改php設定參數
sed -i 's/max_execution_time = 30/max_execution_time = 300/g' /etc/php.ini
sed -i 's/max_input_time = 60/max_input_time = 300/g' /etc/php.ini
sed -i 's/memory_limit = 128M/memory_limit = 256M/g' /etc/php.ini
sed -i 's/post_max_size = 8M/post_max_size = 32M/g' /etc/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 16M/g' /etc/php.ini
sed -i 's/;date.timezone =/date.timezone = Asia\/Taipei/g' /etc/php.ini
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php.ini
#防火牆設定
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --reload
#下載Open-Audit
wget http://dl-openaudit.opmantek.com/OAE-Linux-x86_64-release_2.1.1.run
#設定執行權限
chmod +x OAE-Linux-x86_64-release_2.1.1.run
#安裝Open-Audit
sudo ./OAE-Linux-x86_64-release_2.1.1.run
