yum update -y
yum install epel-release wget -y
yum install cacti -y
echo "[Webmin]" > /etc/yum.repos.d/webmin.repo
echo "name=Webmin Distribution Neutral" >> /etc/yum.repos.d/webmin.repo
echo "mirrorlist=http://download.webmin.com/download/yum/mirrorlist" >> /etc/yum.repos.d/webmin.repo
echo "enabled=1" >> /etc/yum.repos.d/webmin.repo
wget http://www.webmin.com/jcameron-key.asc
rpm --import jcameron-key.asc
yum install webmin -y
