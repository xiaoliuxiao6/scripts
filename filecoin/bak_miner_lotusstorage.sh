#!/bin/bash
set -o errexit 
set -o nounset

## 准备脚本 - 石家庄用
cat <<\EOF > /usr/local/bin/bak_miner
#!/bin/bash
set -o errexit 
set -o nounset

bak_miner(){
    echo "备份 Miner 目录开始 `date`"
    des_ip="10.1.7.2"
    des_path="/home/xinke/disk_md0/bak_from_`hostname`"
    src_path="/home/xinke/disk_md0/6block/data/lotusstorage"

    ssh root@${des_ip} "mkdir -p ${des_path}"
    
    shell="rsync -aH --delete --progress ${src_path} root@${des_ip}:${des_path}"
    ${shell}
    echo "bak_miner_last_time `date +%s`" > /usr/local/node_exporter/textfile_collector/bak_miner.prom
    echo "备份 Miner 目录结束 `date`"
}

while true
do
    ## 修改 SSH Client 设置
    sed -i '/StrictHostKeyChecking/d' /etc/ssh/ssh_config
    echo 'StrictHostKeyChecking no' >> /etc/ssh/ssh_config
    bak_miner
    sleep 3600
done
EOF

chmod +x /usr/local/bin/bak_miner

## 注册为服务
## 准备配置文件
cat <<\EOF > /etc/systemd/system/bak_miner.service
[Unit]
Description="自动备份 Miner 目录"

[Service]
Restart=always
RestartSec=5
ExecStart=/usr/local/bin/bak_miner

[Install]
WantedBy=multi-user.target
EOF

## 启动并设置开机自动启动
systemctl daemon-reload
systemctl enable bak_miner.service
systemctl stop bak_miner.service
systemctl start bak_miner.service
systemctl status bak_miner.service
# journalctl -f -u bak_miner.service
