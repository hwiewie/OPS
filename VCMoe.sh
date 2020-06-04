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
    echo "檢測到系統為:CentOS7,安裝7系運行庫,並關閉系統防火牆"
    yum clean all
	yum makecache
	yum -y install glibc.i686
	yum install -y xulrunner.i686
	yum install -y libXtst.i686
	yum -y install gcc gcc-c++ make zlib-devel
	echo " "
	echo "開始關閉防火牆"
	echo " "
	systemctl disable firewalld
	systemctl stop firewalld
	systemctl disable firewalld.service
	systemctl stop firewalld.service
	echo " "
	echo "防火牆關閉完成"
	echo " "
}

function Swap() {
	B=`awk '/MemTotal/{printf("%1.f\n",$2/1024/1024)}' /proc/meminfo`
	a=9
	AA=$(($a - $B))
	if (($AA > 1)); then
	echo "系統根據運行內存自動添加Swap請耐心等待..."
    dd if=/dev/zero of=/var/swap.1 bs=${AA}M count=1000
    mkswap /var/swap.1
    swapon /var/swap.1
    echo "/var/swap.1 swap swap defaults 0 0" >>/etc/fstab
    sed -i 's/swapoff -a/#swapoff -a/g' /etc/rc.d/rc.local
	echo "添加 Swap 成功"
	elif (($AA <= 1)); then
	echo " 系統檢測運行內≤8G不需要添加Swap"	
	fi
}

function ChangeIP() {
    echo -n "	${IP}
	是否是你的外網IP？ (不是你的外網IP或出現兩條IP地址請回n自行輸入) y/n ："
    read ans
    case $ans in
    y|Y|yes|Yes)
    ;;
    n|N|no|No)
    read -p "輸入你的外網IP地址，回車（確保是英文字符的點號）：" myip
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
	echo -n "完成安裝，是否刪除臨時文件 y/n [n] ?"
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
	echo "毒奶粉服務端已經安裝完畢!
	"
	echo "登錄器網關默認使用5系系統專用網關,如果您的小雞是6系(7系未測試),請刪除root目錄下文件'DnfGateServer',並修改'DnfGateServer CentOS6'文件名為'DnfGateServer'
	"
	echo "啟動服務端命令為cd 回車再./run，關閉命令為cd 回車再./stop兩次
	"
	echo "數據庫默認帳號為：root，默認密碼為：vcmoe
	"
	echo "數據庫目錄：opt/lampp/var/mysql
	"
	echo "本服務端及腳本只使用到了XAMPP的MySQL,其他功能均未配置使用且版本較老,如有需求,請自行配置
	"
	echo "MySQL數據庫用戶只保留了服務端必須使用到的用戶名為game的本地用戶,用於phpMyAdmin的本地用戶pma(phpMyAdmin默認並未配置使用!)
	"	
	echo "以及用於外網處理數據庫的root用戶,如有需要,請自行添加!
	"
