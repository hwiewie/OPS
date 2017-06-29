in/bash
#Author: ZhangGe
#Date & Time: 2014-06-24 12:22:40
#Description: Name server monitoring.
#目标域名
site=$1
site=${site:-www.baidu.com}
#解析延时阈值
expect=$2
expect=${expect:-0.05}
#获取内网IP作为标示
InterIp()
{
        ifconfigIP=`/sbin/ifconfig -a|awk '/10\./||/10\./||/11\./'|head -n 1|awk '{print $2}'|awk -F: '{print $2}'`
        ifconfigIP=`echo $ifconfigIP|grep '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
}
InterIp
#获取域名解析时间
delay=`curl -o /dev/null -s -w %{time_namelookup} $site`
#比较与报警(sendmesg是公用消息发送脚本)
if [ $? -eq 0 ];then
        if [ `expr $delay \> $expect` == 1 ];
        then
           /usr/local/t_mon/sendmesg.sh zhangge "$ifconfigIP NS Delay $delay s"
        fi
else
           /usr/local/t_mon/sendmesg.sh zhagnge "$ifconfigIP Name Server Error"
fi
exit 0
