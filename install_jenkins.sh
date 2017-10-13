#!/bin/bash
yum update
yum -y install epel-release telnet bind-utils net-tools wget nc python-pip perl gcc make kernel-headers kernel-devel mod_perl2
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
systemctl start httpd
systemctl enable httpd
firewall-cmd --zone=public --permanent --add-port=80/tcp
firewall-cmd --reload
yum install http://mirror.globo.com/epel/7/x86_64/e/epel-release-7-10.noarch.rpm
wget http://ftp.otrs.org/pub/otrs/RPMS/rhel/7/otrs-6.0.0.beta3-01.noarch.rpm
yum install check otrs-6.0.0.beta3-01.noarch.rpm
yum install "perl(Text::CSV_XS)" "perl(Crypt::Eksblowfish::Bcrypt)" "perl(YAML::XS)" "perl(JSON::XS)" "perl(Encode::HanExtra)" "perl(Mail::IMAPClient)" "perl(ModPerl::Util)" "perl(DBD::Pg)" "perl(Authen::NTLM)"
/opt/otrs/bin/otrs.CheckModules.pl
