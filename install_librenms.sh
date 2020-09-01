yum install -y epel-release
yum install -y bash-completion cronie fping git ImageMagick mtr net-snmp net-snmp-utils nginx nmap php-fpm php-cli php-common php-curl php-gd php-json php-mbstring php-process php-snmp php-xml php-zip php-mysqlnd python3 python3-PyMySQL python3-redis python3-memcached python3-pip rrdtool unzip
yum install -y yum-utils http://rpms.remirepo.net/enterprise/remi-release-8.rpm
yum module reset php -y
yum module enable php:remi-7.4 -y
yum install -y mod_php php-cli php-common php-curl php-gd php-mbstring php-process php-snmp php-xml php-zip php-memcached php-mysqlnd
