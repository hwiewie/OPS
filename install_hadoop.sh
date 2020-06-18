#!/bin/bash
export PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin
##
sudo apt update -y
sudo apt-get install ssh pdsh -y
sudo apt-get install openjdk-8-jdk -y
sudo adduser hadoop
sudo usermod -aG sudo hadoop
sudo su hadoop
