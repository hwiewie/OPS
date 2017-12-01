#VPS安裝(proxy採用docker container建置)
#取得變數
ipaddr=`ss -t | grep ssh | awk '{ print $4}' | awk -F':' '{print $1}'`
echo "VPS地區選擇："
echo "請輸入地區代號：
echo " 1：江蘇  2：廣東  3：廣西  4：河北  5：福建"
echo " 6：淅江  7：貴州  8：河南  9：江西 10：北京"
echo "11：湖南 12：四川 13：山東 14：上海 15：安徵"
echo "16：遼寧 17：吉林 18：重慶 19：湖北 20：黑龍江"
echo "21：天津 22：陝西 23：山西"
read -p "請輸入VPS所在地區代號: " NewName
case "$NewName" in
"JSU")
    agentname="Jiangsu_WebMonitor"
    ;;
"GD")
    agentname="Jiangsu_WebMonitor"
    ;;
"GX")
    agentname="Guangxi_WebMonitor"
    ;;
"HP")
    agentname="Hebei_WebMonitor"
    ;;
"FJ")
    agentname="Forjen_WebMonitor"
    ;;
"JJ")
    agentname="JaiJang_WebMonitor"
    ;;
"GJ")
    agentname="Guizhou_WebMonitor"
    ;;
"HN")
    agentname="Henan_WebMonitor"
    ;;
"JS")
    agentname="Changsha_WebMonitor"
    ;;
"BJ")
    agentname="Beijing_WebMonitor"
    ;;
"WN")
    agentname="WhoNan_WebMonitor"
    ;;
"FH")
    agentname="Sichuan_WebMonitor"
    ;;
"SD")
    agentname="Shandong_WebMonitor"
    ;;
"SH")
    agentname="Shanghai_WebMonitor"
    ;;
"AH")
    agentname="Anhui_WebMonitor"
    ;;
"LL")
    agentname="LauLen_WebMonitor"
    ;;
"JL")
    agentname="Jelin_WebMonitor"
    ;;
"BJ")
    agentname="Beijing_WebMonitor"
    ;;
"BJ")
    agentname="Beijing_WebMonitor"
    ;;
"BJ")
    agentname="Beijing_WebMonitor"
    ;;
"BJ")
    agentname="Beijing_WebMonitor"
    ;;
"BJ")
    agentname="Beijing_WebMonitor"
    ;;
"BJ")
    agentname="Beijing_WebMonitor"
    ;;
esac

#改VPS的hostname
hostname $NewName
echo $NewName > /etc/hostname

#安裝套件
yum update -y
yum install bind-utils net-tools httping lynx iptables-services docker -y

#關閉Selinux
setenforce 0
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config
sed -i 's/SELINUXTYPE=targeted/#SELINUXTYPE=targeted/g' /etc/sysconfig/selinux

#設定iptables
cp /etc/sysconfig/iptables /etc/sysconfig/iptables.bak
curl -s https://raw.githubusercontent.com/hwiewie/OPS/master/iptables -o "/etc/sysconfig/iptables"

#設定NAT
echo 1 > /proc/sys/net/ipv4/ip_forward
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sysctl -p /etc/sysctl.conf
sysctl -w net.ipv4.ip_forward=1

service iptables restart

#設定本機DNS服務
yum install dnsmasq -y
cp /etc/resolv.conf /etc/resolv.dnsmasq.conf
cp /etc/hosts /etc/dnsmasq.hosts
cp /etc/dnsmasq.conf /etc/dnsmasq.conf.bak
echo 'resolv-file=/etc/resolv.dnsmasq.conf' >> /etc/dnsmasq.conf
echo 'addn-hosts=/etc/dnsmasq.hosts' >> /etc/dnsmasq.conf
echo 'cache-size=10000' >> /etc/dnsmasq.conf

service dnsmasq start
echo 'nameserver 127.0.0.1' > /etc/resolv.conf
systemctl enable dnsmasq
chkconfig dnsmasq on

#設定docker
echo "{" > /etc/docker/daemon.json
echo '"registry-mirrors": ["https://registry.docker-cn.com"]' >> /etc/docker/daemon.json
echo "}" >> /etc/docker/daemon.json

#啟動docker
service docker start
chkconfig docker on

#安裝zabbix agent
rpm -ivh http://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-agent-3.4.4-2.el7.x86_64.rpm
systemctl enable zabbix-agent
#修改zabbix agent 設定檔
sed -i "s/Server=127.0.0.1/Server=172.17.0.3/g" /etc/zabbix/zabbix_agentd.conf
sed -i "s/ServerActive=127.0.0.1/ServerActive=$ipaddr/g" /etc/zabbix/zabbix_agentd.conf
sed -i "s/Hostname=Zabbix server/Hostname=$agentname/g" /etc/zabbix/zabbix_agentd.conf
#下載psk
curl -s https://raw.githubusercontent.com/nickchangs/zabbix-agent2/master/zabbix_agentd.psk -o "/etc/zabbix/zabbix_agentd.psk"
#建立目錄
mkdir /usr/lib/zabbix
mkdir /usr/lib/zabbix/enc
mkdir /usr/lib/zabbix/mibs
mkdir /usr/lib/zabbix/modules
mkdir /usr/lib/zabbix/snmptraps
mkdir /usr/lib/zabbix/ssh_keys
mkdir /usr/lib/zabbix/ssl
mkdir /usr/lib/zabbix/ssl/certs
mkdir /usr/lib/zabbix/ssl/keys
mkdir /usr/lib/zabbix/ssl/ssl_ca
echo "89bf5832dfa1dcfc7c7f5d640c457270f4d9724b1a58530612424e4dd8fd45f7" > /usr/lib/zabbix/enc/zabbix_agentd.psk
systemctl start zabbix-agent
