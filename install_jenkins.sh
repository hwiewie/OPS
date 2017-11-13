#!/bin/bash
yum update
yum -y install epel-release
yum -y install telnet bind-utils net-tools wget nc python-pip perl gcc make kernel-headers kernel-devel mod_perl2
pip install --upgrade pip
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

echo "安裝vmware tools"
mkdir /mnt/cdrom
mount /dev/cdrom /mnt/cdrom
tar xzvf /mnt/cdrom/VMwareTools-10.0.6-3560309.tar.gz -C /tmp/
cd /tmp/vmware-tools-distrib/
./vmware-install.pl

echo "安裝jenkins"
wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import http://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum -y install java jenkins
systemctl start jenkins
systemctl enable jenkins
firewall-cmd --zone=public --permanent --add-port=8080/tcp
firewall-cmd --reload

echo "安裝otrs"
yum -y install httpd mariadb-server mod_ssl
systemctl start mariadb
systemctl enable mariadb
mysql_secure_installation
systemctl start httpd
systemctl enable httpd
firewall-cmd --zone=public --permanent --add-port=80/tcp
firewall-cmd --reload
yum install http://mirror.globo.com/epel/7/x86_64/e/epel-release-7-10.noarch.rpm
wget http://ftp.otrs.org/pub/otrs/RPMS/rhel/7/otrs-6.0.0.beta3-01.noarch.rpm
yum install check otrs-6.0.0.beta3-01.noarch.rpm
yum install "perl(Text::CSV_XS)" "perl(Crypt::Eksblowfish::Bcrypt)" "perl(YAML::XS)" "perl(JSON::XS)" "perl(Encode::HanExtra)" "perl(Mail::IMAPClient)" "perl(ModPerl::Util)" "perl(DBD::Pg)" "perl(Authen::NTLM)"
/opt/otrs/bin/otrs.CheckModules.pl
mysql -u root -p
create database otrs character set utf8 collate utf8_bin ;
grant all privileges on otrs.* to otrs@localhost identified by "some-pass";
flush privileges;
quit;
mysql -u root -p otrs < /opt/otrs/scripts/database/otrs-schema.mysql.sql
systemctl restart mariadb
systemctl restart httpd
http://172.16.100.134/otrs/installer.pl

echo "安裝gitlab"
yum install git
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
firewall-cmd --permanent --add-service=http
systemctl reload firewalld
curl -s https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | sudo bash
yum install gitlab-ce
gitlab-ctl reconfigure

echo "安裝iTop"
yum install php php-mysql php-mcrypt php-xml php-cli php-soap php-ldap php-gd graphviz
systemctl restart httpd

echo "安裝docker"
yum install docker

echo "安裝Galera Cluster Server"
echo "[mariadb]" > /etc/yum.repos.d/MariaDB.repo
echo "name = MariaDB" >> /etc/yum.repos.d/MariaDB.repo
echo "baseurl = http://yum.mariadb.org/10.2/centos7-amd64" >> /etc/yum.repos.d/MariaDB.repo
echo "gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB" >> /etc/yum.repos.d/MariaDB.repo
echo "gpgcheck=1" >> /etc/yum.repos.d/MariaDB.repo
yum -y install MariaDB-server MariaDB-client
#yum -y install MariaDB-Galera-server MariaDB-client galera

systemctl start mariadb
systemctl enable mariadb
mysql_secure_installation

cp /usr/share/mysql/wsrep.cnf /etc/my.cnf.d/
vi /etc/my.cnf.d/wsrep.cnf
sed -i 's/wsrep_provider=none/wsrep_provider=\/usr\/lib64\/galera\/libgalera_smm.so/g' /etc/my.cnf.d/wsrep.cnf


----------第一台-----------
wsrep_provider=/usr/lib64/galera/libgalera_smm.so >> /etc/my.cnf.d/server.cnf
wsrep_cluster_address="gcomm://" >> /etc/my.cnf.d/server.cnf
wsrep_sst_auth=sst_user:dbpass >> /etc/my.cnf.d/server.cnf

firewall-cmd --add-port=3306/tcp
firewall-cmd --add-port=4567/tcp
firewall-cmd --permanent --add-port=3306/tcp
firewall-cmd --permanent --add-port=4567/tcp
------------第二台-----------------
wsrep_provider=/usr/lib64/galera/libgalera_smm.so >> /etc/my.cnf.d/server.cnf
wsrep_cluster_address="gcomm://172.16.100.133:4567" >> /etc/my.cnf.d/server.cnf
wsrep_sst_auth=sst_user:dbpass >> /etc/my.cnf.d/server.cnf

firewall-cmd --add-port=3306/tcp
firewall-cmd --permanent --add-port=3306/tcp
---------------------------------
mysql -uroot -p
GRANT USAGE ON *.* to sst_user@'%' IDENTIFIED BY 'dbpass';
GRANT USAGE ON *.* to sst_user@'localhost' IDENTIFIED BY 'dbpass';
GRANT ALL PRIVILEGES on *.* to sst_user@'%';
GRANT ALL PRIVILEGES on *.* to sst_user@'localhost';
quit

systemctl start mariadb
------如果第二台啟動失敗---
rm -rf /var/lock/subsys/mysql
rm -rf /var/lib/mysql/galera.cache
rm -rf /var/lib/mysql/grastate.dat
galera_new_cluster
/etc/init.d/mysql start
--------------------

