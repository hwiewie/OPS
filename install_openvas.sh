
sed -i 's/=enforcing/=disabled/' /etc/selinux/config
firewall-cmd --zone=public --add-port=9392/tcp --permanent
firewall-cmd --reload
#yum -y update && reboot
yum -y install wget
wget -q -O - https://www.atomicorp.com/installers/atomic | sh
yum -y install openvas
sed -i '/^#.*unixsocket/s/^# //' /etc/redis.conf
systemctl enable redis && systemctl restart redis
openvas-setup

#https://www.linuxincluded.com/installing-openvas-on-centos-7/
#https://cloud.tencent.com/info/39a2d8ef1b2398df7982628b1e566bc8.html
