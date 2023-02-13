#!/bin/sh
set -o errexit 
set -o nounset

## 删除 ssh 主机密钥
rm -rf /etc/ssh/ssh_host_*

## 从 `/etc/sysconfig/network-scripts/ifcfg-eth*` 中删除 `HWADDR` 行和 `UUID` 行。
[[ `grep -l HWADDR /etc/sysconfig/network-scripts/ifcfg-* | wc -l` -gt 0 ]] && sed -i "/HWADDR/d" `grep -l HWADDR /etc/sysconfig/network-scripts/ifcfg-*`
[[ `grep -l UUID /etc/sysconfig/network-scripts/ifcfg-* | wc -l` -gt 0 ]] && sed -i "/UUID/d" `grep -l UUID /etc/sysconfig/network-scripts/ifcfg-*`


## 删除日志
rm -rf /var/log/*

## 删除 History
cat /dev/null > ~/.bash_history

## 运行 sys-unconfig
sys-unconfig