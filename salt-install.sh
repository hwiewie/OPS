#!/bin/bash
#salt auto install script
#pki存放路徑：/etc/salt/pki/master/minions，有問題機器直接把在此目錄內那台機器名稱的檔案砍掉
read -p "Input hostname you want to change ,ex:001-500vip-fe-03 : " NewName
#判斷OS版本
release=`cat /etc/redhat-release | awk -F "release" '{print $2}' |awk -F "." '{print $1}' |sed 's/ //g'`
if [ $release = 7 ];then
    yum -y install https://repo.saltstack.com/yum/redhat/salt-repo-latest-2.el7.noarch.rpm
elif [ $release = 6 ];then
    yum -y install https://repo.saltstack.com/yum/redhat/salt-repo-latest-2.el6.noarch.rpm
fi
yum -y install salt-minion
if [ $release = 7 ];then
    systemctl enable salt-minion
elif [ $release = 6 ];then
    chkconfig salt-minion on
fi
service salt-minion start
echo $NewName > /etc/salt/minion_id
echo "master: 61.216.144.184" >> /etc/salt/minion
service salt-minion restart
