rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
echo '[elasticsearch-7.x]' >> /etc/yum.repos.d/elasticsearch.repo
echo 'name=Elasticsearch repository for 7.x packages' >> /etc/yum.repos.d/elasticsearch.repo
echo 'baseurl=https://artifacts.elastic.co/packages/7.x/yum' >> /etc/yum.repos.d/elasticsearch.repo
echo 'gpgcheck=1' >> /etc/yum.repos.d/elasticsearch.repo
echo 'gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch' >> /etc/yum.repos.d/elasticsearch.repo
echo 'enabled=1' >> /etc/yum.repos.d/elasticsearch.repo
echo 'autorefresh=1' >> /etc/yum.repos.d/elasticsearch.repo
echo 'type=rpm-md' >> /etc/yum.repos.d/elasticsearch.repo
yum install -y java
java -version
dnf install -y elasticsearch
sed -i 's/-Xms1g/-Xms32g/g' /etc/elasticsearch/jvm.options
sed -i 's/-Xmx1g/-Xmx32g/g' /etc/elasticsearch/jvm.options
sed -i 's/#cluster.name: my-application/cluster.name: i8-ELK/g' /etc/elasticsearch/elasticsearch.yml
sed -i 's/#node.name: node-1/node.name: i8-ELK-01/g' /etc/elasticsearch/elasticsearch.yml
sed -i '/#node.attr.rack/anode.attr.box_type: hot' /etc/elasticsearch/elasticsearch.yml
sed -i 's/#network.host: 192.168.0.1/network.host: 0.0.0.0/g' /etc/elasticsearch/elasticsearch.yml
echo 'vm.max_map_count=262144' >> /etc/sysctl.conf
systemctl enable --now elasticsearch
firewall-cmd --permanent --new-service=ELK
firewall-cmd --reloadfirewall-cmd --permanent --service=ELK --set-short="ELK Service Ports"
firewall-cmd --permanent --service=ELK --set-description="Logstash service firewalld port exceptions"
firewall-cmd --permanent --service=ELK --add-port=5044/tcp
firewall-cmd --permanent --service=ELK --add-port=5601/tcp
firewall-cmd --permanent --service=ELK --add-port=9200/tcp
firewall-cmd --permanent --service=ELK --add-port=9300/tcp
firewall-cmd --permanent --service=ELK --add-port=9600/tcp
firewall-cmd --permanent --add-service=ELK
firewall-cmd --reload
sed -i '/^# End of file/i elasticsearch    soft    nofile          65536' /etc/security/limits.conf
sed -i '/^# End of file/i elasticsearch    hard    nofile          65536' /etc/security/limits.conf
sed -i '/^# End of file/i elasticsearch    soft    nproc           4096' /etc/security/limits.conf
sed -i '/^# End of file/i elasticsearch    hard    nproc           4096' /etc/security/limits.conf
sed -i '/^# End of file/i logstash         hard    nofile          16384' /etc/security/limits.conf
sed -i '/^# End of file/i logstash         soft    nofile          16384' /etc/security/limits.conf
sed -i '/swap/s/^/#/' /etc/fstab
swapoff -a
echo "net.ipv4.ip_local_port_range = 1024 65000" >> /etc/sysctl.conf
echo "net.netfilter.nf_conntrack_max = 10240" >> /etc/sysctl.conf
sysctl -p

yum install -y logstash
sed -i -e 's|# path.logs:|path.logs: /var/log/logstash|' -e 's|# path.data:|path.data: /var/lib/logstash|' /etc/logstash/logstash.yml
/usr/share/logstash/bin/system-install /etc/logstash/startup.options
chown -R logstash:logstash /usr/share/logstash
chown -R logstash /var/log/logstash
chown logstash:logstash /var/lib/logstash
chown -R logstash:logstash /etc/logstash
chown -R logstash:logstash /etc/default/logstash
systemctl enable --now logstash
