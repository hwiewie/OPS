#!/bin/sh
#設定db密碼
dbpasswd=1234567
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
sed -i 's/server 0.centos.pool.ntp.org iburst/server tock.stdtime.gov.tw iburst/g' /etc/chrony.conf
sed -i 's/server 1.centos.pool.ntp.org iburst/server watch.stdtime.gov.tw iburst/g' /etc/chrony.conf
sed -i 's/server 2.centos.pool.ntp.org iburst/server tick.stdtime.gov.tw iburst/g' /etc/chrony.conf
sed -i 's/server 3.centos.pool.ntp.org iburst/server clock.stdtime.gov.tw iburst/g' /etc/chrony.conf
sed -i '/watch.stdtime.gov.tw/a server time.stdtime.gov.tw iburst' /etc/chrony.conf
systemctl restart chronyd
chronyc -a makestep
echo "[grafana]" > /etc/yum.repos.d/grafana.repo
echo "name=grafana" >> /etc/yum.repos.d/grafana.repo
echo 'baseurl=https://packagecloud.io/grafana/stable/el/7/$basearch' >> /etc/yum.repos.d/grafana.repo
echo "repo_gpgcheck=1" >> /etc/yum.repos.d/grafana.repo
echo "enabled=1" >> /etc/yum.repos.d/grafana.repo
echo "gpgcheck=1" >> /etc/yum.repos.d/grafana.repo
echo "gpgkey=https://packagecloud.io/gpg.key https://grafanarel.s3.amazonaws.com/RPM-GPG-KEY-grafana" >> /etc/yum.repos.d/grafana.repo
echo "sslverify=1" >> /etc/yum.repos.d/grafana.repo
echo "sslcacert=/etc/pki/tls/certs/ca-bundle.crt" >> /etc/yum.repos.d/grafana.repo
yum -y install epel-release
yum update -y
yum -y install telnet bind-utils net-tools wget nc python-pip perl gcc make
mkdir /mnt/cdrom
mount /dev/cdrom /mnt/cdrom
tar xzvf /mnt/cdrom/VMwareTools-10.1.7-5541682.tar.gz -C /tmp/
cd /tmp/vmware-tools-distrib/
./vmware-install.pl
yum -y install https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/pgdg-centos10-10-2.noarch.rpm
yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum -y install http://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm
yum -y install nmap perl perl-core bzip2 git net-snmp* libcurl-devel
yum-config-manager --enable remi-php72
yum -y install httpd postgresql10 postgresql10-server postgresql10-libs zabbix-server-pgsql zabbix-web-pgsql
yum --enablerepo=remi,remi-php72 -y install php php-common php-cli php-pdo php-fpm php-pgsql php-gd php-mbstring php-mcrypt php-xml php-ldap php-snmp php-opcache php-imap php-xmlrpc php-pecl-apcu php-soap php-pecl-zip
sed -i 's/max_execution_time = 30/max_execution_time = 600/g' /etc/php.ini
sed -i 's/max_input_time = 60/max_input_time = 300/g' /etc/php.ini
sed -i 's/memory_limit = 128M/memory_limit = 256M/g' /etc/php.ini
sed -i 's/post_max_size = 8M/post_max_size = 32M/g' /etc/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 16M/g' /etc/php.ini
sed -i 's/;date.timezone =/date.timezone = Asia\/Taipei/g' /etc/php.ini
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php.ini
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --permanent --add-service=postgresql
firewall-cmd --permanent --add-port=3000/tcp
firewall-cmd --permanent --add-port=10051/tcp
firewall-cmd --reload
systemctl start httpd
systemctl enable httpd
/usr/pgsql-10/bin/postgresql-10-setup initdb
sed -i '/^host.*all.*all.*127.*ident/s/ident/md5/' /var/lib/pgsql/10/data/pg_hba.conf
systemctl start postgresql-10
systemctl enable postgresql-10
sed -i '/# DBHost=localhost/aDBHost=' /etc/zabbix/zabbix_server.conf
sed -i '/DBPassword=/aDBPassword=$dbpasswd' /etc/zabbix/zabbix_server.conf
sed -i '/# StartSNMPTrapper=0/aStartSNMPTrapper=1' /etc/zabbix/zabbix_server.conf
systemctl start zabbix-server
systemctl enable zabbix-server
sed -i '/.1.3.6.1.2.1.25.1.1/aview    systemview    included   .1' /etc/snmp/snmpd.conf
sed -i 's/#proc mountd/proc mountd/g' /etc/snmp/snmpd.conf
sed -i 's/#proc ntalkd 4/proc ntalkd 4/g' /etc/snmp/snmpd.conf
sed -i 's/#proc sendmail 10 1/proc sendmail 10 1/g' /etc/snmp/snmpd.conf
sed -i 's/#disk \/ 10000/disk \/ 10000/g' /etc/snmp/snmpd.conf
sed -i 's/#load 12 14 14/load 12 14 14/g' /etc/snmp/snmpd.conf
sed -i 's/LogFileSize=0/LogFileSize=30/g' /etc/zabbix/zabbix_agentd.conf
sed -i '/# RefreshActiveChecks=120/aRefreshActiveChecks=60' /etc/zabbix/zabbix_agentd.conf
sed -i '/# BufferSend=5/aBufferSend=10' /etc/zabbix/zabbix_agentd.conf
#echo 'UserParameter=ip.connections[*],(/etc/zabbix/connections.sh $1)' > /etc/zabbix/zabbix_agentd.d/userparameter_ip.conf
#echo 'UserParameter=httping.loss[*],(/etc/zabbix/httping.sh $1 $2)' > /etc/zabbix/zabbix_agentd.d/userparameter_httping.conf
#echo 'UserParameter=httping.avg[*],(/etc/zabbix/httping.sh $1 $2)' > /etc/zabbix/zabbix_agentd.d/userparameter_httping.conf
systemctl start zabbix-agent
systemctl enable zabbix-agent
sed -i '/.1.3.6.1.2.1.25.1.1/aview    systemview    included   .1' /etc/snmp/snmpd.conf
sed -i 's/#proc mountd/proc mountd/g' /etc/snmp/snmpd.conf
sed -i 's/#proc ntalkd 4/proc ntalkd 4/g' /etc/snmp/snmpd.conf
sed -i 's/#proc sendmail 10 1/proc sendmail 10 1/g' /etc/snmp/snmpd.conf
sed -i 's/#disk \/ 10000/disk \/ 10000/g' /etc/snmp/snmpd.conf
sed -i 's/#load 12 14 14/load 12 14 14/g' /etc/snmp/snmpd.conf
systemctl start snmpd
systemctl enable snmpd
sed -i '29azabbix hard nofile 10240' /etc/security/limits.conf
sed -i '29azabbix soft nofile 10240' /etc/security/limits.conf
sed -i '29aapache hard nofile 10240' /etc/security/limits.conf
sed -i '29aapache soft nofile 10240' /etc/security/limits.conf
sed -i '29apostgres hard nofile 10240' /etc/security/limits.conf
sed -i '29apostgres soft nofile 10240' /etc/security/limits.conf
systemctl daemon-reload
#sed -i '/$last = strtolower(substr($val, -1));/a$val = substr($val,0,-1);' /usr/share/zabbix/include/func.inc.php
#sed -i 's/7.0/7.4/g' /usr/share/zabbix/include/classes/setup/CFrontendSetup.php
yum -y install grafana
chown -R grafana:grafana /var/lib/grafana
grafana-cli plugins install alexanderzobnin-zabbix-app
systemctl start grafana-server.service
systemctl enable grafana-server.service
# 下面指令需手動執行
######################################################################
##改postgres的密碼並建立資料庫與使用者
# su - postgres -c "psql"
# \password postgres
# create role zabbix login ;
# \password zabbix
# create database zabbix with template template0 encoding 'UTF8' ;
# grant all on database zabbix to zabbix;
# \q
#####################################################################
##導入DB schema
# cd /usr/share/doc/zabbix-server-pgsql-3.4.8/ 
# gunzip create.sql.gz 
# psql -h 127.0.0.1 -d zabbix -U zabbix -p 5432 -f create.sql
#####################################################################
