yum update
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
sed -i 's/server 0.centos.pool.ntp.org iburst/server tock.stdtime.gov.tw iburst/g' /etc/chrony.conf
sed -i 's/server 1.centos.pool.ntp.org iburst/server watch.stdtime.gov.tw iburst/g' /etc/chrony.conf
sed -i 's/server 2.centos.pool.ntp.org iburst/server tick.stdtime.gov.tw iburst/g' /etc/chrony.conf
sed -i 's/server 3.centos.pool.ntp.org iburst/server clock.stdtime.gov.tw iburst/g' /etc/chrony.conf
sed -i '/watch.stdtime.gov.tw/a server time.stdtime.gov.tw iburst' /etc/chrony.conf
systemctl restart chronyd
chronyc -a makestep
yum -y install epel-release
yum -y install vim yum-utils telnet bind-utils net-tools wget perl perl-core gcc gcc-multilib bzip2 git net-snmp* libcurl-devel g++ gawk m4 make smbclient openssl* perl-Crypt-OpenSSL-X509 libcap-*
yum install squid
mkdir /usr/share/squid/ssl_cert
cd /usr/share/squid/ssl_cert/

firewall-cmd --permanent --add-service=squid
firewall-cmd --reload
yum install dnsmasq
systemctl start dnsmasq
systemctl enable dnsmasq
