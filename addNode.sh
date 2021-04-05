#!/bin/bash
#
# rhel7.4 安裝node_exporter 用於監控數據採集
# Usage:
# sh addNode.sh
#Logs: /var/log/messages
#History: 2019/8/2 v3
#Create_Time: 2019-08-02
# USE: small_wei
#
#

WEB_PATH='http://12.0.94.46:8086' #這裡是我測試環境下的文件下載鏈接路徑
# https://github.com/prometheus/node_exporter 官方下載地址


Install_PATH=/opt/node
Server_file=/usr/lib/systemd/system
RED_COLOR='\E[1;31m' #紅
GREEN_COLOR='\E[1;32m' #綠
RES='\E[0m'

node_user=node
node_group=node
Time_date=$(date +"%Y%m%d%H%M%S")

if [ ! $(id -u) == 0 ];then
    echo -e "${GREEN_COLOR}Please run with the root user!${RES}"
    exit 22
fi

#防止重複執行
if [ $(ps -ef | grep $0 |grep -v grep | wc -l) -gt 2 ];then #理論值為 1 ， 但這裡是 2
        echo -e "${RED_COLOR} $0 The script is executing, do not repeat!, Run id is $$${RES}"
        exit 22
fi


#create group if not exists
egrep "^${node_group}" /etc/group 2>/dev/null
if [ $? -ne 0 ];then
    groupadd ${node_group}
    echo -e "${node_group} group Creating a successful"
fi
 
#create user if not exists
egrep "^${node_user}" /etc/passwd 2>/dev/null
if [ $? -ne 0 ];then
    useradd -g ${node_group} ${node_user}
    echo -e "${node_user} user Creating a successful"
fi


port=`netstat -anp|grep 9100`
if test -z "${port}"
then
    mkdir -p ${Install_PATH}
    chown -R ${node_user}:${node_user} ${Install_PATH}
    wget -p ${Install_PATH} $WEB_PATH/downloadFile/node_exporter
    chmod +x ${Install_PATH}/node_exporter
    if [[ $? == 0 ]];then
        echo -e "${GREEN_COLOR}Environment readiness complete${RES}"
    fi
#-----------------
    if [ -f "${Server_file}/node_exporter.service" ];then
        cp -f ${Server_file}/node_exporter.service ${Server_file}/node_exporter.service.bak${Time_date}
    fi

    if [ $? == 0 ];then
        echo -e "${GREEN_COLOR}node_exporter.service.bak${Time_date} File The backup successful${RES}"
    else
        echo -e "${RED_COLOR}node_exporter.service.bak${Time_date} File backup failed${RES}"
        exit 22
    fi
    cat >${Server_file}/node_exporter.service <<-EOF
    [Unit]
    Description=Prometheus node exporter
    Documentation=https://prometheus.io/
    After=local-fs.target network-online.target network.target
    Wants=local-fs.target network-online.target network.target
    
    [Service]
    User=${node_user}
    Group=${node_group}
    Type=simple
    #ExecStart=${Install_PATH}/node_exporter --web.listen-address=:9100 --log.level=error
    ExecStart=${Install_PATH}/node_exporter --web.listen-address=:9100 --log.level=info

    [Install]
    WantedBy=multi-user.target
    EOF

    systemctl daemon-reload
    systemctl restart node_exporter

    if [ $? == 0 ];then
        echo -e "${GREEN_COLOR}node_exporte Server start success!${RES}"
    else
        echo -e "${RED_COLOR}node_exporte Server start ERROR!${RES}"
        exit 22
    fi
#------------------
else
    echo -e "${GREEN_COLOR}port:9100 is busy,failed${RES}"
fi

systemctl enable node_exporter
systemctl status node_exporter


#驗證
curl -I -m 3 -o /dev/null -s -w %{http_code} 127.0.0.1:9100 \n

if [ $? == 0 ];then
    echo -e "${GREEN_COLOR}register node in consul success${RES}"
else
    echo -e "${RED_COLOR}Registration failed or registered, please check! ${RES}"
    exit 22
fi 
