#!/bin/sh
#安裝必要php擴充功能
yum -y install php72-php-gd php72-php-xml php72-php-mbstring
#下載Mediawiki
cd /tmp
wget https://releases.wikimedia.org/mediawiki/1.30/mediawiki-1.30.0.tar.gz
tar -zvxf mediawiki-1.30.0.tar.gz
mv mediawiki-1.30.0 /var/www/html/mediawiki
chown -R nginx:nginx /var/www/html/mediawiki/
#啟用mbstring
sed -i 's/;zend.multibyte = Off/zend.multibyte = On/g' /etc/opt/remi/php72/php.ini
systemctl restart nginx
#解決session存放路徑沒權限
chown -R nginx:nginx /var/opt/remi/php72/lib/php/
#selinux設定
restorecon -FR /var/www/html/mediawiki
