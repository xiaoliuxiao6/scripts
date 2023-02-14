一些常用脚本


## CentOS 7
#### 初始化
- 修改尽量不占用 SWAP
- 禁用登录 SSH 时候解析主机名称
- 关闭 SeLinux
- 关闭防火墙
- 禁用IPV6
- 修改时区为 +0800
- 配置从阿里云服务器进行时间同步
- 安装常用软件和中文支持
- 更新系统

```sh
curl -sL https://raw.githubusercontent.com/xiaoliuxiao6/scripts/main/centos7_init.sh | sh -
```

#### 优化
生产环境中一些必要设置和美化
```sh
curl -sL https://raw.githubusercontent.com/xiaoliuxiao6/scripts/main/centos7_youhua.sh | sh -
```

#### 封装
删除历史记录等，以便将其转换为模板
```sh
curl -sL https://raw.githubusercontent.com/xiaoliuxiao6/scripts/main/centos7_unconfig.sh | sh -
logout

cat /dev/null > ~/.bash_history
sys-unconfig
```
