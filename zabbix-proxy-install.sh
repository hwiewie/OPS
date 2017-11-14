#!/bin/bash
zabbix_version=3.4.4.2
release=`cat /etc/redhat-release | awk -F "release" '{print $2}' |awk -F "." '{print $1}' |sed 's/ //g'`

yum update
yum -y install epel-release
yum -y install telnet bind-utils net-tools wget nc python-pip perl gcc make kernel-headers kernel-devel
pip install --upgrade pip
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
sed -i 's/SELINUXTYPE=targeted/#SELINUXTYPE=targeted/g' /etc/sysconfig/selinux
#安裝MARIADB-SERVER
echo "[mariadb]" > /etc/yum.repos.d/MariaDB.repo
echo "name = MariaDB" >> /etc/yum.repos.d/MariaDB.repo
if [ $release = 7 ];then
    echo "baseurl = http://yum.mariadb.org/10.2/centos7-amd64/" >> /etc/yum.repos.d/MariaDB.repo
elif [ $release = 6 ];then
    echo "baseurl = http://yum.mariadb.org/10.2/centos6-amd64/" >> /etc/yum.repos.d/MariaDB.repo
fi
echo "gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB" >> /etc/yum.repos.d/MariaDB.repo
echo "gpgcheck=1" >> /etc/yum.repos.d/MariaDB.repo
yum -y install mariadb-server
#開機啟動及啟用
systemctl start mariadb
systemctl enable mariadb
#安裝zabbix 3.4 RPM關聯
if [ $release = 7 ];then
    rpm -ivh http://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4.4-2.el7.noarch.rpm
elif [ $release = 6 ];then
    rpm -ivh http://repo.zabbix.com/zabbix/3.4/rhel/6/x86_64/zabbix-release-3.4-1.el6.noarch.rpm
fi
#安裝zabbix proxy mysql
yum -y install zabbix-proxy-mysql
#安裝zabbix agent 3.4.2
yum -y install zabbix-agent
#安裝zabbix連mysql套件
yum -y install zabbix-server-mysql zabbix-web-mysql
#設定開機啟動
systemctl enable zabbix-proxy
systemctl enable zabbix-agent
#設定zabbix proxy設定檔
#vi /etc/zabbix/zabbix_proxy.conf
#Server=61.216.144.184
#ServerPort=10051
#Hostname=TJ
#LogFile=/var/log/zabbix/zabbix_proxy.log
#LogFileSize=0
#PidFile=/var/run/zabbix/zabbix_proxy.pid
#DBHost=localhost
#DBName=zabbix_proxy
#DBUser=zabbix
#DBPassword=zabbix
#StartHTTPPollers=50
#SNMPTrapperFile=/var/log/snmptrap/snmptrap.log
#Timeout=4
#ExternalScripts=/usr/lib/zabbix/externalscripts
#LogSlowQueries=3000
#TLSConnect=psk
#TLSAccept=psk
#TLSPSKIdentity=PSK 001
#TLSPSKFile=/etc/zabbix/zabbix_agentd.psk
#設定zabbix agent設定檔
#vi /etc/zabbix/zabbix_agentd.conf
#PidFile=/var/run/zabbix/zabbix_agentd.pid
#LogFile=/var/log/zabbix/zabbix_agentd.log
#LogFileSize=0
#SourceIP=172.16.100.132
#Server=127.0.0.1,172.16.100.132
#ServerActive=127.0.0.1,172.16.100.131
#Hostname=vSRV-OA-Zabbix-Proxy
#Timeout=10
#AllowRoot=1
#Include=/etc/zabbix/zabbix_agentd.d/*.conf
#設定mariadb-server
#mysql -u root -p
#create database zabbix_proxy character set utf8 collate utf8_bin;
#grant all privileges on zabbix_proxy.* to zabbix@’localhost’ identified by "zabbix";
#flush privileges;
#exit
#導入DB
zcat /usr/share/doc/zabbix-proxy-mysql-3.4.2/schema.sql.gz | mysql -uroot zabbix_proxy
#設定防火牆
iptables -I INPUT -s 61.216.144.184 -j ACCEPT
iptables -I INPUT -s 61.216.144.186 -j ACCEPT
iptables -I INPUT -s 58.218.198.140 -j ACCEPT
iptables -I INPUT -s 121.201.126.154 -j ACCEPT
iptables -I INPUT -s 218.65.131.23 -j ACCEPT
iptables -I INPUT -s 121.18.238.84 -j ACCEPT
iptables -I INPUT -s 125.211.218.83 -j ACCEPT
iptables -I INPUT -s 122.228.244.207 -j ACCEPT
iptables -I INPUT -s 123.249.34.189 -j ACCEPT
iptables -I INPUT -s 117.21.191.101 -j ACCEPT
iptables -I INPUT -s 119.90.126.103 -j ACCEPT
iptables -I INPUT -s 124.232.137.43 -j ACCEPT
iptables -I INPUT -s 118.123.243.214 -j ACCEPT
iptables -I INPUT -s 27.221.52.39 -j ACCEPT
iptables -I INPUT -s 221.181.73.38 -j ACCEPT
iptables -I INPUT -s 60.169.77.177 -j ACCEPT
iptables -I INPUT -s 59.45.175.118 -j ACCEPT
iptables -I INPUT -s 202.111.175.61 -j ACCEPT
iptables -I INPUT -s 219.153.49.198 -j ACCEPT
iptables -I INPUT -s 219.138.135.102 -j ACCEPT
iptables -I INPUT -s 125.211.222.160 -j ACCEPT
iptables -I INPUT -s 111.161.65.109 -j ACCEPT
iptables -I INPUT -s 117.34.109.53 -j ACCEPT
iptables -I INPUT -s 124.164.232.146 -j ACCEPT
iptables -I INPUT -s 222.88.94.206 -j ACCEPT
iptables -I INPUT -s 1.162.210.176 -j ACCEPT
iptables -I INPUT -s 218.85.133.210 -j ACCEPT
iptables -I INPUT -s 127.0.0.1 -j ACCEPT
#-A INPUT -m conntrack -j ACCEPT  --ctstate RELATED,ESTABLISHED
#-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
#-A INPUT -j DROP
#-A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
#-A FORWARD -j DROP
#COMMIT
#本地端dns服務安裝設定
cp /etc/resolv.conf /etc/resolv.dnsmasq.conf
cp /etc/hosts /etc/dnsmasq.hosts
cp /etc/dnsmasq.conf /etc/dnsmasq.conf.bak
echo 'listen-address=127.0.0.1' >> /etc/dnsmasq.conf
echo 'resolv-file=/etc/resolv.dnsmasq.conf' >> /etc/dnsmasq.conf
echo 'addn-hosts=/etc/dnsmasq.hosts' >> /etc/dnsmasq.conf
echo 'cache-size=1000' >> /etc/dnsmasq.conf
echo 'nameserver 127.0.0.1' > /etc/resolv.conf
service dnsmasq start
systemctl enable dnsmasq
chkconfig dnsmasq on
