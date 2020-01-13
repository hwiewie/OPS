#install docker step
#yum install -y yum-utils device-mapper-persistent-data lvm2
#yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
#yum-config-manager --enable docker-ce-nightly
##yum install -y http://mirror.centos.org/centos/7/extras/x86_64/Packages/container-selinux-2.107-3.el7.noarch.rpm
#yum install -y docker-ce docker-ce-cli containerd.io
#yum install -y /path/to/package.rpm
#rpm -vhU https://nmap.org/dist/nmap-7.80-1.x86_64.rpm
#systemctl start docker
#systemctl enable docker
#firewall-cmd --permanent --add-service=https
#firewall-cmd --permanent --add-service=http
#firewall-cmd --reload
docker volume create openvas
docker run -d -p 443:443 -p 9390:9390 -v openvas:/var/lib/openvas/mgr -e OV_UPDATE=yes --name openvas atomicorp/openvas
#docker exec -it openvas bash
## inside container
#greenbone-nvt-sync
#openvasmd --rebuild --progress
#greenbone-certdata-sync
#greenbone-scapdata-sync
#openvasmd --update --verbose --progress
#/etc/init.d/openvas-manager restart
#/etc/init.d/openvas-scanner restart
