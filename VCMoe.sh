#!/bin/sh

function install() {
    echo "nameserver 114.114.114.114">> /etc/resolv.conf
	centos=`cat /etc/redhat-release`
    XT=`cat /etc/redhat-release | awk '{print $3}'| cut -b1`
	H=`cat /proc/cpuinfo | grep "physical id" | sort | uniq | wc -l`
	HX=`cat /proc/cpuinfo | grep "core id" |wc -l`
	DD=`df -h /`
    W=`getconf LONG_BIT`
	G=`awk '/MemTotal/{printf("%1.1fG\n",$2/1024/1024)}' /proc/meminfo`
	SJ=`date '+%Y-%m-%d %H:%M:%S'`
    IP=`curl -s http://v4.ipv6-test.com/api/myip.php`
    if [ -z $IP ]; then
    IP=`curl -s https://www.boip.net/api/myip`
    fi
	echo "
================================服務器配置================================

| 系統版本 | |CPU個數| |CPU核心| |運行內存| |操作系統|
|$centos| | $H個 | | $HX核 | | $G | | $W 位 |

===============================硬盤使用情況================ ===============
$DD	

"	
	echo "	歡迎使用MJJ專用毒奶粉私服一鍵端腳本
	"

	echo "  本腳本會自動識別5.x系6.x系7.x系的CentOS系統,安裝相應的支持庫
	"
	
	echo "  但是強烈建議使用5系64位系統,CentOS 5.8 x64為最佳!因為高版本進程優先級的問題,會導致服務端啟動非常之慢!  
	"	
	
	echo "  服務端數據庫需要使用MySQL,因為考慮到編譯安裝MySQL比較費時且費事,
	"

	echo "  為了方便以及減少各種問題本人已集成了老版本的XAMPP 1.8.1,不放心的可以自行編譯安裝MySQL
	"	

	echo "  本腳本和打包的服務端程序完全開源無加密,請放心檢查
	"	
	
	echo "  本腳本會自動添加虛擬內存,以達到低內存的小雞也可以正常運行服務端
	"
	
	echo "  腳本完全免費,僅限於各位MJJ自行研究以及與朋友娛樂使用,請勿用於商業用途!
	"
	
	echo "  千萬不要用作商業用途!千萬不要用作商業用途!千萬不要用作商業用途!
	"
	
	echo "  千萬不要想著開區!千萬不要想著開區!千萬不要想著開區!
	"
    echo -n "	
	同意的話請輸入 OJBK ：" 
	read TRY
	while [ "$TRY" != "OJBK" ]; do
	echo "輸入有誤，請重新輸入："
	echo -n "	
	輸入有誤，請重新輸入："
	read TRY
	done
	CheckAndStopFireWall
	Swap
    ChangeIP
    Remove
}

function CheckAndStopFireWall() {
	if [ "$XT" = "5" ] ; then
		CentOS5
	elif [ "$XT" = "6" ] ; then
		CentOS6
	elif [ "$XT" = "r" ] ; then
		Centos7
    else
        exit 0
    fi
}

function CentOS5() {
    echo "檢測到系統為:CentOS5,安裝5系運行庫,並關閉系統防火牆"
    yum clean all
	yum makecache
	yum -y install glibc.i386
	yum install -y xulrunner.i386
	yum install -y libXtst.i386
	yum -y install gcc gcc-c++ make zlib-devel
	echo " "
	echo "開始關閉防火牆"
	echo " "
	service iptables stop
	chkconfig iptables off
	echo " "
	echo "防火牆關閉完成"
	echo " "
}

function CentOS6() {
    echo "檢測到系統為:CentOS6,安裝6系運行庫,並關閉系統防火牆"
    yum clean all
	yum makecache
	yum -y install glibc.i686
	yum install -y xulrunner.i686
	yum install -y libXtst.i686
	yum -y install gcc gcc-c++ make zlib-devel
	echo " "
	echo "開始關閉防火牆"
	echo " "
	service iptables stop
	chkconfig iptables off
	echo " "
	echo "防火牆關閉完成"
	echo " "
}

function CentOS7() {
    echo "	检测到系统为:CentOS7,安装7系运行库,并关闭系统防火墙"
    yum clean all
	yum makecache
	yum -y install glibc.i686
	yum install -y xulrunner.i686
	yum install -y libXtst.i686
	yum -y install gcc gcc-c++ make zlib-devel
	echo " "
	echo "开始关闭防火墙"
	echo " "
	systemctl disable firewalld
	systemctl stop firewalld
	systemctl disable firewalld.service
	systemctl stop firewalld.service
	echo " "
	echo "防火墙关闭完成"
	echo " "
}

function Swap() {
	B=`awk '/MemTotal/{printf("%1.f\n",$2/1024/1024)}' /proc/meminfo`
	a=9
	AA=$(($a - $B))
	if (($AA > 1)); then
	echo "	系统根据运行内存自动添加Swap请耐心等待..."
    dd if=/dev/zero of=/var/swap.1 bs=${AA}M count=1000
    mkswap /var/swap.1
    swapon /var/swap.1
    echo "/var/swap.1 swap swap defaults 0 0" >>/etc/fstab
    sed -i 's/swapoff -a/#swapoff -a/g' /etc/rc.d/rc.local
	echo "添加 Swap 成功"
	elif (($AA <= 1)); then
	echo "	系统检测运行内≤8G不需要添加Swap"	
	fi
}

function ChangeIP() {
    echo -n "	${IP}
	是否是你的外网IP？(不是你的外网IP或出现两条IP地址请回n自行输入) y/n ："
    read ans
    case $ans in
    y|Y|yes|Yes)
    ;;
    n|N|no|No)
    read -p "	输入你的外网IP地址，回车（确保是英文字符的点号）：" myip
    IP=$myip
    ;;
    *)
    ;;
    esac
    cd /
	tar -zvxf VCMoe.tar.gz
    cd /home/neople
	sed -i "s/Need Change/${IP}/g" `find . -type f -name "*.cfg"`
	echo 1 > cat /proc/sys/vm/drop_caches
	sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/sysconfig/selinux
}

function Remove() {
	echo -n "	完成安装，是否删除临时文件 y/n [n] ?"
    read ANS
    case $ANS in
    y|Y|yes|Yes)
    rm -f /VCMoe.tar.gz
	rm -f /VCMoe
    ;;
    n|N|no|No)
    ;;
    *)
    ;;
    esac
}

install
	echo "毒奶粉服务端已经安装完毕！
	"
	echo "登录器网关默认使用5系系统专用网关,如果您的小鸡是6系(7系未测试),请删除root目录下文件'DnfGateServer',并修改'DnfGateServer CentOS6'文件名为'DnfGateServer'
	"
	echo "启动服务端命令为cd 回车再./run，关闭命令为cd 回车再./stop两次
	"
	echo "数据库默认帐号为：root，默认密码为：vcmoe
	"
	echo "数据库目录：opt/lampp/var/mysql
	"
	echo "本服务端及脚本只使用到了XAMPP的MySQL,其他功能均未配置使用且版本较老,如有需求,请自行配置
	"
	echo "MySQL数据库用户只保留了服务端必须使用到的用户名为game的本地用户,用于phpMyAdmin的本地用户pma(phpMyAdmin默认并未配置使用!)
	"	
	echo "以及用于外网处理数据库的root用户,如有需要,请自行添加!
	"
