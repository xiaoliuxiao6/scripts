#!/bin/sh
set -o errexit
set -o nounset

##############################################################################
## 修改 history 行为
##############################################################################
## 删除原有设置
sed -i '/^HISTSIZE/d' /root/.bashrc
sed -i '/^HISTFILESIZE/d' /root/.bashrc
sed -i '/^HISTTIMEFORMAT/d' /root/.bashrc
sed -i '/^PROMPT_COMMAND/d' /root/.bashrc
sed -i '/^shopt -s/d' /root/.bashrc

## 追加新设置
cat <<\EOF >> /root/.bashrc
## 追加而不是覆盖
shopt -s histappend
## 定义命令输出的行数
HISTSIZE=1000
## 定义最多保留的条数
HISTFILESIZE=10000
## 记录执行命令的时间和用户名
HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S:`whoami` "
## 实时追加，不必等用户退出
PROMPT_COMMAND="history -a"
## 当终端窗口大小改变时，确保显示得到更新
shopt -s checkwinsize
EOF

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
# setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config

################################################################################################
## 关闭防火墙
################################################################################################
systemctl stop firewalld.service
systemctl disable firewalld.service

################################################################################################
## 禁用IPV6
################################################################################################
[[ `grep -l IPV6 /etc/sysconfig/network-scripts/ifcfg-* | wc -l` -gt 0 ]] && sed -i "/IPV6/d" `grep -l IPV6 /etc/sysconfig/network-scripts/ifcfg-*`
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

echoCyan(){
    echo -e "\033[36m$*\033[0m"
}

echoCyan "Success, will restart"
init 6
