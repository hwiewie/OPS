#!/bin/sh

#關閉SElinux
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
#設定網路校時
sed -i 's/server 0.centos.pool.ntp.org iburst/server tock.stdtime.gov.tw iburst/g' /etc/chrony.conf
sed -i 's/server 1.centos.pool.ntp.org iburst/server watch.stdtime.gov.tw iburst/g' /etc/chrony.conf
sed -i 's/server 2.centos.pool.ntp.org iburst/server tick.stdtime.gov.tw iburst/g' /etc/chrony.conf
sed -i 's/server 3.centos.pool.ntp.org iburst/server clock.stdtime.gov.tw iburst/g' /etc/chrony.conf
systemctl restart chronyd
chronyc -a makestep
#設定防火牆
firewall-cmd --permanent --add-service=http
firewall-cmd --reload
#新增nginx知識庫
echo "[nginx]" >> /etc/yum.repos.d/nginx.repo
echo "name=nginx repo" >> /etc/yum.repos.d/nginx.repo
echo 'baseurl=http://nginx.org/packages/centos/7/$basearch/' >> /etc/yum.repos.d/nginx.repo
echo "gpgcheck=0" >> /etc/yum.repos.d/nginx.repo
echo "enabled=1" >> /etc/yum.repos.d/nginx.repo
#新增Mariadb資源庫
echo "[mariadb]" >> /etc/yum.repos.d/MariaDB.repo
echo "name = MariaDB" >> /etc/yum.repos.d/MariaDB.repo
echo "baseurl = http://yum.mariadb.org/10.2/centos7-amd64" >> /etc/yum.repos.d/MariaDB.repo
echo "gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB" >> /etc/yum.repos.d/MariaDB.repo
echo "gpgcheck=1" >> /etc/yum.repos.d/MariaDB.repo
#安裝epel知識庫
yum -y install epel-release
#更新Linux
yum -y update
#安裝常用套件
yum -y install yum-utils telnet bind-utils net-tools wget nc
#安裝LAMP
yum -y install nginx mariadb-server
yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum-config-manager --enable remi-php72
yum install php72 php72-php-fpm php72-php-gd php72-php-mbstring php72-php-mysqlnd php72-php-xml php72-php-xmlrpc php72-php-pecl-mcrypt php72-php-bcmath php72-php-opcache php72-php-ldap php72-php-pear
#設定
scl enable php72 bash
#修改php-fpm的使用者為nginx
sed -i 's/user = apache/user = nginx/g' /etc/opt/remi/php72/php-fpm.d/www.conf
sed -i 's/group = apache/group = nginx/g' /etc/opt/remi/php72/php-fpm.d/www.conf
#賦予使用者nginx有php-fpm相關目錄執行權限
chown nginx /var/opt/remi/php72/log/php-fpm
chown -R nginx:nginx /var/opt/remi/php72/lib/php/
#啟動php-fpm
systemctl restart php-fpm
systemctl enable php-fpm
#設定php.ini
sed -i 's/max_execution_time = 30/max_execution_time = 300/g' /etc/opt/remi/php72/php.ini
sed -i 's/max_input_time = 60/max_input_time = 300/g' /etc/opt/remi/php72/php.ini
sed -i 's/memory_limit = 128M/memory_limit = 256M/g' /etc/opt/remi/php72/php.ini
sed -i 's/post_max_size = 8M/post_max_size = 32M/g' /etc/opt/remi/php72/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 16M/g' /etc/opt/remi/php72/php.ini
sed -i 's/;date.timezone =/date.timezone = Asia\/Taipei/g' /etc/opt/remi/php72/php.ini
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/opt/remi/php72/php.ini
#修改nginx.conf設定fastcgi
sed -i 's/worker_processes  1/worker_processes  4/g' /etc/nginx/nginx.conf
sed -i 's/worker_connections  1024/worker_connections  10240/g' /etc/nginx/nginx.conf
sed -i 's/#tcp_nopush/tcp_nopush/g' /etc/nginx/nginx.conf
sed -i '/tcp_nopush/a    tcp_nodelay    on;' /etc/nginx/nginx.conf
sed -i 's/keepalive_timeout  65/keepalive_timeout  120/g' /etc/nginx/nginx.conf
sed -i '/gzip/a    fastcgi_read_timeout 300;' /etc/nginx/nginx.conf
sed -i '/gzip/a    fastcgi_send_timeout 300;' /etc/nginx/nginx.conf
sed -i '/gzip/a    fastcgi_connect_timeout 300;' /etc/nginx/nginx.conf
sed -i '/gzip/a    fastcgi_temp_file_write_size 128k;' /etc/nginx/nginx.conf
sed -i '/gzip/a    fastcgi_busy_buffers_size 128k;' /etc/nginx/nginx.conf
sed -i '/gzip/a    fastcgi_buffers 32 32k;' /etc/nginx/nginx.conf
sed -i '/gzip/a    fastcgi_buffer_size 128k;' /etc/nginx/nginx.conf
#啟動nginx
systemctl start nginx
systemctl enable nginx

#安裝Mantis
wget https://excellmedia.dl.sourceforge.net/project/mantisbt/mantis-stable/2.4.1/mantisbt-2.12.0.tar.gz
tar -xpf mantisbt-2.12.0.tar.gz
mv mantisbt-2.12.0 /var/www/html/mantisbt
chown -R nginx:nginx /var/www/html/mantisbt/
#新增虛擬站台設定
echo "server {" >> /etc/nginx/conf.d/mantisbt.conf
echo "    listen       80;" >> /etc/nginx/conf.d/mantisbt.conf
echo "    index index.html index.php;" >> /etc/nginx/conf.d/mantisbt.conf
echo "    root /var/www/html/mantisbt;" >> /etc/nginx/conf.d/mantisbt.conf
echo ""  >> /etc/nginx/conf.d/mantisbt.conf
echo "    location /mantisbt {" >> /etc/nginx/conf.d/mantisbt.conf
echo "        alias                       /var/www/html/mantisbt;" >> /etc/nginx/conf.d/mantisbt.conf
echo "        index                       index.php;" >> /etc/nginx/conf.d/mantisbt.conf
echo "        error_page          403 404 502 503 504  /mantisbt/index.php;" >> /etc/nginx/conf.d/mantisbt.conf
echo "        location ~ \.php$ {" >> /etc/nginx/conf.d/mantisbt.conf
echo '            if (!-f $request_filename) { return 404; }' >> /etc/nginx/conf.d/mantisbt.conf
echo "            expires                 epoch;" >> /etc/nginx/conf.d/mantisbt.conf
echo "            fastcgi_buffer_size 128k;" >> /etc/nginx/conf.d/mantisbt.conf
echo "            fastcgi_buffers 32 32k;" >> /etc/nginx/conf.d/mantisbt.conf
echo "            include                 /etc/nginx/fastcgi_params;" >> /etc/nginx/conf.d/mantisbt.conf
echo "            fastcgi_split_path_info ^(.+\.php)(/.+)$;" >> /etc/nginx/conf.d/mantisbt.conf
echo "            fastcgi_index           index.php;" >> /etc/nginx/conf.d/mantisbt.conf
echo "            fastcgi_pass           127.0.0.1:9000;" >> /etc/nginx/conf.d/mantisbt.conf
echo '            fastcgi_param SCRIPT_FILENAME $request_filename;' >> /etc/nginx/conf.d/mantisbt.conf
echo "         }" >> /etc/nginx/conf.d/mantisbt.conf
echo "" >> /etc/nginx/conf.d/mantisbt.conf
echo "         location ~ \.(jpg|jpeg|gif|png|ico)$ {" >> /etc/nginx/conf.d/mantisbt.conf
echo "             access_log      off;" >> /etc/nginx/conf.d/mantisbt.conf
echo "             expires         33d;" >> /etc/nginx/conf.d/mantisbt.conf
echo "         }" >> /etc/nginx/conf.d/mantisbt.conf
echo "    }" >> /etc/nginx/conf.d/mantisbt.conf
echo "}" >> /etc/nginx/conf.d/mantisbt.conf
