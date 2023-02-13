一些常用脚本


## CentOS 7
#### 初始化
一些基本的通用修改，可以放心使用
```sh
curl -sfL https://raw.githubusercontent.com/xiaoliuxiao6/scripts/main/init_centos7.sh | sh -
```

## 封装
删除历史记录等，以便将其转换为模板
```sh
curl -sfL https://raw.githubusercontent.com/xiaoliuxiao6/scripts/main/unconfig_centos7.sh | sh -
cat /dev/null > ~/.bash_history
sys-unconfig
```
