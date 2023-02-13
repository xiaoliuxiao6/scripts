#!/bin/sh

## 如果发现退出码为1则停止运行
set -o errexit 
## 如果发现空的变量则停止运行
set -o nounset

################################################################################################
## 修改尽量不占用 SWAP
################################################################################################
sed -i "/swappiness/d" /etc/sysctl.conf
echo "vm.swappiness=1" >> /etc/sysctl.conf
sysctl -p

################################################################################################
## 禁用登录 SSH 时候解析主机名称
################################################################################################
echo 'UseDNS no' >> /etc/ssh/sshd_config

################################################################################################
## 关闭 SeLinux
################################################################################################
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config

################################################################################################
## 关闭防火墙
################################################################################################
systemctl stop firewalld.service
systemctl disable firewalld.service

################################################################################################
## 禁用IPV6
################################################################################################
sed -i "/IPV6/d" /etc/sysconfig/ifcfg-*
echo 'net.ipv6.conf.all.disable_ipv6=1' >> /etc/sysctl.conf
echo 'net.ipv6.conf.default.disable_ipv6=1' >> /etc/sysctl.conf
sysctl -p

################################################################################################
## 修改时区（最好的方法是使用timedatectl命令）
################################################################################################
timedatectl set-timezone Asia/Shanghai

################################################################################################
## 配置阿里云NTP时间同步服务
################################################################################################
## 1.安装 chrony 并配置（时间同步客户端）
yum install -y chrony

# 删除默认Server
sed -i "/server/d" /etc/chrony.conf
# 新增阿里云服务器
echo "server ntp.aliyun.com iburst" >>/etc/chrony.conf

## 2.重启服务并查看状态是否正常并设置开机自动启动
systemctl enable chronyd
systemctl restart chronyd
chronyc tracking

## 3.将当前的 UTC 时间写入硬件时钟
timedatectl set-local-rtc 0

################################################################################################
## 安装常用软件
################################################################################################
yum install -y vim \
                wget \
                net-tools \
                unzip \
                bash-completion \
                rsync \
                lrzsz \
                kde-l10n-Chinese \
                glibc-common

################################################################################################
## 更新
################################################################################################
yum update -y

echo "执行完毕 `date`"