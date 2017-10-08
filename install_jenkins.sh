#!/bin/bash
yum update
yum -y install epel-release telnet bind-utils net-tools wget nc python-pip perl gcc make kernel-headers kernel-devel

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
