yum install https://repo.saltstack.com/yum/redhat/salt-repo-latest-2.el7.noarch.rpm -y  
yum install salt-minion -y  
systemctl enable salt-minion  
service salt-minion start  

echo "032-cp1-pay-01" > /etc/salt/minion_id  
echo "master: 61.216.144.184" >> /etc/salt/minion  
echo "tcp_keepalive: True" >> /etc/salt/minion  
echo "tcp_keepalive_idle: 60" >> /etc/salt/minion  
service salt-minion restart
