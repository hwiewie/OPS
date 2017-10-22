#!/bin/bash
yum update
yum -y install epel-release
yum -y install telnet bind-utils net-tools wget nc python-pip perl gcc make kernel-headers kernel-devel
pip install --upgrade pip
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
#安裝MARIADB-SERVER
yum -y install mariadb-server
#開機啟動及啟用
systemctl start mariadb
systemctl enable mariadb
#安裝zabbix 3.4 RPM關聯
rpm -ivh http://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm
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
