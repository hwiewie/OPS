#!/bin/sh
#讀取CentOS版本
release=`cat /etc/redhat-release | awk -F "release" '{print $2}' |awk -F "." '{print $1}' |sed 's/ //g'`
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
#新增elasticsearch知識庫
echo '[elasticsearch-6.x]' >> /etc/yum.repos.d/elasticsearch.repo
echo 'name=Elasticsearch repository for 6.x packages' >> /etc/yum.repos.d/elasticsearch.repo
echo 'baseurl=https://artifacts.elastic.co/packages/6.x/yum' >> /etc/yum.repos.d/elasticsearch.repo
echo 'gpgcheck=1' >> /etc/yum.repos.d/elasticsearch.repo
echo 'gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch' >> /etc/yum.repos.d/elasticsearch.repo
echo 'enabled=1' >> /etc/yum.repos.d/elasticsearch.repo
echo 'autorefresh=1' >> /etc/yum.repos.d/elasticsearch.repo
echo 'type=rpm-md' >> /etc/yum.repos.d/elasticsearch.repo
#新增kibana知識庫
echo '[kibana-6.x]' >> /etc/yum.repos.d/elasticsearch.repo
echo 'name=Kibana repository for 6.x packages' >> /etc/yum.repos.d/elasticsearch.repo
echo 'baseurl=https://artifacts.elastic.co/packages/6.x/yum' >> /etc/yum.repos.d/elasticsearch.repo
echo 'gpgcheck=1' >> /etc/yum.repos.d/elasticsearch.repo
echo 'gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch' >> /etc/yum.repos.d/elasticsearch.repo
echo 'enabled=1' >> /etc/yum.repos.d/elasticsearch.repo
echo 'autorefresh=1' >> /etc/yum.repos.d/elasticsearch.repo
echo 'type=rpm-md' >> /etc/yum.repos.d/elasticsearch.repo
#新增logstash知識庫
echo '[logstash-6.x]' >> /etc/yum.repos.d/logstash.repo
echo 'name=Elastic repository for 6.x packages' >> /etc/yum.repos.d/logstash.repo
echo 'baseurl=https://artifacts.elastic.co/packages/6.x/yum' >> /etc/yum.repos.d/logstash.repo
echo 'gpgcheck=1' >> /etc/yum.repos.d/logstash.repo
echo 'gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch' >> /etc/yum.repos.d/logstash.repo
echo 'enabled=1' >> /etc/yum.repos.d/logstash.repo
echo 'autorefresh=1' >> /etc/yum.repos.d/logstash.repo
echo 'type=rpm-md' >> /etc/yum.repos.d/logstash.repo
#更新與安裝必要元件
yum -y install epel-release
yum -y update
yum -y install telnet bind-utils net-tools wget nc
#安裝Java(1.8版以上)
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u162-b12/0da788060d494f5095bf8624735fa2f1/jdk-8u162-linux-x64.rpm"
rpm -ivh jdk-8u162-linux-x64.rpm
java -version
#安裝Elasticsearch
yum install elasticsearch
#修改設定
sed -i 's/-Xmx1g/-Xmx8g/g' /etc/elasticsearch/jvm.options
sed -i 's/#MAX_LOCKED_MEMORY=unlimited/MAX_LOCKED_MEMORY=unlimited/g' /etc/sysconfig/elasticsearch
sed -i 's/#JAVA_HOME=/JAVA_HOME=/usr/lib/jvm/g' /etc/sysconfig/elasticsearch
echo "LimitMEMLOCK=infinity" >> /usr/lib/systemd/system/elasticsearch.service
systemctl daemon-reload
#加入開機啟動
chkconfig --add elasticsearch
#執行elasticsearch
service elasticsearch start
#安裝插件
#/usr/share/logstash/bin/elasticsearch-plugin install x-pack
#安裝Logstash
yum install logstash
#設定
sed -i -e 's|# path.logs:|path.logs: /var/log/logstash|' -e 's|# path.data:|path.data: /var/lib/logstash|' /etc/logstash/logstash.yml
#初始化logstash
/usr/share/logstash/bin/system-install /etc/logstash/startup.options
#修改目錄權限
chown -R logstash:logstash /usr/share/logstash
chown -R logstash /var/log/logstash
chown logstash:logstash /var/lib/logstash
chown -R logstash:logstash /etc/logstash
chown -R logstash:logstash /etc/default/logstash
#啟動logstash
if [ $release = 7 ];then
   systemctl start logstash
elif [ $release = 6 ];then 
   initctl start logstash
fi
#加入開機啟動
chkconfig --add logstash
#安裝plugin
#/usr/share/logstash/bin/logstash-plugin install logstash-input-syslog
#安裝kibana
yum install kibana
#執行kibana
service kibana start
#加入開機啟動
chkconfig kibana on
#設定防火牆
firewall-cmd --permanent --add-port=5601/tcp
firewall-cmd --reload
#安裝filebeat
yum install filebeat
#修改設定
sed -i '/output.elasticsearch:/s/^/#/' /etc/filebeat/filebeat.yml
sed -i '/^#output.logstash:/s/#//' /etc/filebeat/filebeat.yml
sed -i '/^#output.logstash:/s/#//' /etc/filebeat/filebeat.yml
sed -i 's/#hosts: ["localhost:5044"]/hosts: ["192.168.1.22:22222"]/g' /etc/filebeat/filebeat.yml
#執行kibana
service filebea start
#加入開機啟動
chkconfig --add filebea
