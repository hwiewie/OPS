#!/bin/bash
export PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin
##
sudo apt update -y
sudo apt-get install ssh pdsh -y
sudo apt-get install openjdk-8-jdk -y
sudo adduser hadoop
sudo usermod -aG sudo hadoop
sudo su hadoop
cd ~
ssh-keygen -t rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys
sudo wget http://www-us.apache.org/dist/hadoop/common/hadoop-3.2.1/hadoop-3.2.1.tar.gz
tar -zxvf hadoop-3.2.1.tar.gz
ln -s hadoop-3.2.1 hadoop
sudo sed -i '117 a\export PDSH_RCMD_TYPE=ssh\nexport HADOOP_HOME="/home/hadoop/hadoop-3.2.1"\nexport PATH=$PATH:$HADOOP_HOME/bin\nexport PATH=$PATH:$HADOOP_HOME/sbin\nexport HADOOP_MAPRED_HOME=${HADOOP_HOME}\nexport HADOOP_COMMON_HOME=${HADOOP_HOME}\nexport HADOOP_HDFS_HOME=${HADOOP_HOME}\nexport YARN_HOME=${HADOOP_HOME}' /home/hadoop/.bashrc
cd ~/hadoop-3.2.1/etc/hadoop/
sudo sed -i "s/\# export JAVA_HOME=/export JAVA_HOME=\/usr\/lib\/jvm\/java-8-openjdk-amd64\//" hadoop-env.sh
sudo sed -i '19 a\<property>\n<name>fs.defaultFS</name>\n<value>hdfs://master:9000</value>\n</property> <property>\n<name>hadoop.tmp.dir</name>\n<value>/home/hadoop/hdata</value>\n</property>' core-site.xml
sudo sed -i '19 a\<property>\n<name>dfs.replication</name>\n<value>1</value>\n</property>' hdfs-site.xml
sudo sed -i '19 a\<property>\n<name>mapreduce.framework.name</name>\n<value>yarn</value>\n</property>' mapred-site.xml
sudo sed -i '17 a\<property>\n<name>yarn.nodemanager.aux-services</name>\n<value>mapreduce_shuffle</value>\n</property>\n<property>\n<name>yarn.nodemanager.aux-services.mapreduce.shuffle.class</name>\n<value>org.apache.hadoop.mapred.ShuffleHandler</value>\n</property>' yarn-site.xml
~/hadoop/bin/hdfs namenode -format
#source /home/hadoop/.bashrc
#cd /home/hadoop/hadoop-3.2.1/sbin
#~/hadoop-3.2.1/sbin/start-dfs.sh
#~/hadoop-3.2.1/sbin/start-yarn.sh
#jps
