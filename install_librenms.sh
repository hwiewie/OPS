yum install -y epel-release
yum install -y bash-completion cronie fping git ImageMagick mysql-server mtr net-snmp net-snmp-utils nginx nmap php-fpm php-cli php-common php-curl php-gd php-json php-mbstring php-process php-snmp php-xml php-zip php-mysqlnd python3 python3-PyMySQL python3-redis python3-memcached python3-pip rrdtool unzip
yum install -y yum-utils http://rpms.remirepo.net/enterprise/remi-release-8.rpm
yum module reset php -y
yum module enable php:remi-7.4 -y
yum install -y mod_php php-cli php-common php-curl php-gd php-mbstring php-process php-snmp php-xml php-zip php-memcached php-mysqlnd php-pdo-dblib
useradd librenms -d /opt/librenms -M -r -s /usr/bin/bash
cd /opt
git clone https://github.com/librenms/librenms.git
chown -R librenms:librenms /opt/librenms
chmod 771 /opt/librenms
setfacl -d -m g::rwx /opt/librenms/rrd /opt/librenms/logs /opt/librenms/bootstrap/cache/ /opt/librenms/storage/
setfacl -R -m g::rwx /opt/librenms/rrd /opt/librenms/logs /opt/librenms/bootstrap/cache/ /opt/librenms/storage/
#su - librenms
#./scripts/composer_wrapper.php install --no-dev
#exit
sed -i 's/;date.timezone =/date.timezone =Asia\/Taipei/g' /etc/php.ini
timedatectl set-timezone Asia/Taipei
systemctl enable --now mysqld
cat > createdb.sql << EOF
CREATE DATABASE librenms CHARACTER SET utf8 COLLATE utf8_unicode_ci;
CREATE USER 'librenms'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON librenms.* TO 'librenms'@'localhost';
FLUSH PRIVILEGES;
exit
EOF
mysql -u root < createdb.sql
cp /etc/php-fpm.d/www.conf /etc/php-fpm.d/librenms.conf
sed -i 's/\[www\]/\[librenms\]/g' /etc/php-fpm.d/librenms.conf
sed -i 's/user = apache/user = librenms/g' /etc/php-fpm.d/librenms.conf
sed -i 's/group = apache/group = librenms/g' /etc/php-fpm.d/librenms.conf
sed -i 's/www.sock/librenms.sock/g' /etc/php-fpm.d/librenms.conf
cat > /etc/nginx/conf.d/librenms.conf << EOF
server {
 listen      80;
 server_name librenms.example.com;
 root        /opt/librenms/html;
 index       index.php;

 charset utf-8;
 gzip on;
 gzip_types text/css application/javascript text/javascript application/x-javascript image/svg+xml text/plain text/xsd text/xsl text/xml image/x-icon;
 location / {
  try_files $uri $uri/ /index.php?\$query_string;
 }
 location ~ [^/]\.php(/|$) {
  fastcgi_pass unix:/run/php-fpm/librenms.sock;
  fastcgi_split_path_info ^(.+\.php)(/.+)$;
  include fastcgi.conf;
 }
 location ~ /\.(?!well-known).* {
  deny all;
 }
}
EOF
sed -i "s/librenms.example.com/`ip addr |grep inet |egrep -v "inet6|127.0.0.1" |awk '{print $2}' |awk -F "/" '{print $1}'`/g" /etc/nginx/conf.d/librenms.conf
cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak #
sed -i '38,57d' /etc/nginx/nginx.conf
systemctl enable --now nginx
systemctl enable --now php-fpm
semanage fcontext -a -t httpd_sys_content_t '/opt/librenms/html(/.*)?'
semanage fcontext -a -t httpd_sys_rw_content_t '/opt/librenms/(logs|rrd|storage)(/.*)?'
restorecon -RFvv /opt/librenms
setsebool -P httpd_can_sendmail=1
setsebool -P httpd_execmem 1
chcon -t httpd_sys_rw_content_t /opt/librenms/.env
cat > http_fping.tt << EOF
module http_fping 1.0;

require {
type httpd_t;
class capability net_raw;
class rawip_socket { getopt create setopt write read };
}

#============= httpd_t ==============
allow httpd_t self:capability net_raw;
allow httpd_t self:rawip_socket { getopt create setopt write read };
EOF
checkmodule -M -m -o http_fping.mod http_fping.tt
semodule_package -o http_fping.pp -m http_fping.mod
semodule -i http_fping.pp
firewall-cmd --add-service={http,https} --permanent
firewall-cmd --reload
ln -s /opt/librenms/lnms /usr/local/bin/lnms
cp /opt/librenms/misc/lnms-completion.bash /etc/bash_completion.d/
mv /etc/snmp/snmpd.conf /etc/snmp/snmpd.conf.bak
cp /opt/librenms/snmpd.conf.example /etc/snmp/snmpd.conf
sed -i "s/RANDOMSTRINGGOESHERE/public/g" /etc/snmp/snmpd.conf
curl -o /usr/bin/distro https://raw.githubusercontent.com/librenms/librenms-agent/master/snmp/distro
chmod +x /usr/bin/distro
systemctl enable snmpd
systemctl restart snmpd
cp /opt/librenms/librenms.nonroot.cron /etc/cron.d/librenms
cp /opt/librenms/misc/librenms.logrotate /etc/logrotate.d/librenms
chown librenms:librenms /opt/librenms/config.php
#sudo su - librenms
#./validate.php
