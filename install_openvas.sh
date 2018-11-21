
sed -i 's/=enforcing/=disabled/' /etc/selinux/config
firewall-cmd --zone=public --add-port=9392/tcp --permanent
firewall-cmd --reload
#yum -y update && reboot
yum -y install wget
wget -q -O - https://www.atomicorp.com/installers/atomic | sh
yum -y install openvas
sed -i '/^#.*unixsocket/s/^# //' /etc/redis.conf
systemctl enable redis && systemctl restart redis


#https://www.linuxincluded.com/installing-openvas-on-centos-7/
