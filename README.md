一些常用脚本


## CentOS 7
#### 初始化
一些基本的通用修改，可以放心使用
```sh
curl -sfL https://raw.githubusercontent.com/xiaoliuxiao6/scripts/main/centos7_init.sh | sh -
```

#### 优化
生产环境中一些必要设置和美化
```sh
curl -sfL https://raw.githubusercontent.com/xiaoliuxiao6/scripts/main/centos7_youhua.sh | sh -
```

#### 封装
删除历史记录等，以便将其转换为模板
```sh
curl -sfL https://raw.githubusercontent.com/xiaoliuxiao6/scripts/main/centos7_unconfig.sh | sh -
cat /dev/null > ~/.bash_history
sys-unconfig
```
