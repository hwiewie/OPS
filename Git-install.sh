#!/bin/sh
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
#安裝 IUS repository
yum install https://centos7.iuscommunity.org/ius-release.rpm
#安裝epel資源庫
yum -y install epel-release
#更新系統
yum -y update
#安裝常用套件
yum -y install yum-utils telnet bind-utils net-tools wget nc git unzip curl-devel expat-devel gettext-devel openssl-devel zlib-devel gcc perl-ExtUtils-MakeMaker
#下載最新的git並安裝
#wget -O git-src.zip https://github.com/git/git/archive/master.zip
#unzip git-src.zip
#cd git-src
#make prefix=/usr/local all
#make prefix=/usr/local install
#ln -fs /usr/local/bin/git* /usr/bin/
#取得Git的更新版
git clone git://git.kernel.org/pub/scm/git/git.git
cd git
make prefix=/usr/local all
make prefix=/usr/local install
#架設伺服器
adduser git
mkdir /opt/git
chown git:git /opt/git
su git
cd
mkdir .ssh
#把開發者的 SSH 公開金鑰增加到這個用戶的 authorized_keys 檔中
#cat /tmp/id\_rsa.john.pub >> ~/.ssh/authorized\_keys
#cat /tmp/id\_rsa.josie.pub >> ~/.ssh/authorized\_keys
#cat /tmp/id\_rsa.jessica.pub >> ~/.ssh/authorized\_keys
#建立一個裸倉庫
cd /opt/git
mkdir project.git
cd project.git
git --bare init
