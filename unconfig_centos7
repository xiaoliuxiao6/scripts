#!/bin/sh

## 如果发现退出码为1则停止运行
set -o errexit 
## 如果发现空的变量则停止运行
set -o nounset

## 删除 ssh 主机密钥
rm -rf /etc/ssh/ssh_host_*

## 从 `/etc/sysconfig/network-scripts/ifcfg-eth*` 中删除 `HWADDR` 行和 `UUID` 行。
grep -l HWADDR /etc/sysconfig/network-scripts/ifcfg-* || sed -i "/HWADDR/d" `grep -l IPV6 /etc/sysconfig/network-scripts/ifcfg-*`
grep -l UUID /etc/sysconfig/network-scripts/ifcfg-* || sed -i "/UUID/d" `grep -l IPV6 /etc/sysconfig/network-scripts/ifcfg-*`

## 删除日志
rm -rf /var/log/*

## 删除 History
rm -f ~/.bash_history

## 运行 sys-unconfig
sys-unconfig
