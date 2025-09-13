# WrtScript

一些学校软路由用的脚本文件罢了

## mac.sh

用来备份/还原机身自己的 mac 地址，会保存到 `/root/mac` 文件，需要更改就自己调

- ./mac.sh backup 进行备份
- ./mac.sh restore 进行还原

## generate_mac.sh

根据一个固定的前缀自动生成后面的 mac 地址，需要自己先调好前缀，**一定一定一定要调**，运行后会换 mac 地址并重新拨号

```bash
# 生成一个随机的MAC地址
generate_mac() {
    # 固定的前缀，格式为 aa:bb:cc
    PREFIX=""
    # ...
}
```

平常使用直接 `./generate_mac.sh` 运行就行

## ip.sh

用来通过 Cloudflare 绑定的域名进行内网 DDNS 的脚本，目的是为了在大内网的其他地方也能够访问到内网的设备

需要自己调整 Cloudflare 的相关内容

新版本同时支持 v6 & v4，只需要配置或留空对应的位置即可

```bash
# Cloudflare API 相关信息
# Cloudflare API 端点，替换为实际的 API URL
CF_API=""
# Cloudflare API Token，换成你自己的
CF_TOKEN=""
# Cloudflare 域名，换成你自己的，这个是你要访问的域名
CF_DOMAIN=""
```

平时使用直接 `./ip.fish` 运行就行

## swap.sh

调整机身的 swap 分区的脚本，避免因软路由自身内存限制导致很多软件无法运行

直接 `./swap.sh` 运行就行

## kc.fish

Keep Connection - 自动检测连接状态并在断线或者新设备加入触发设备踢出时重拨

使用方法：
```bash
./kc.fish
```

配置说明（在脚本开头可配置）：
- `max_retry`: 最大重试次数（默认30次）
- `sleep_time`: 重拨后等待网络稳定时间（秒，默认10秒）
- `overhead_interval`: 正常状态检测间隔（秒，默认3秒）
- `max_fail`: 最大连续失败次数（触发重拨，默认3次）
- `ping_target`: 检测连接的目标地址（默认 https://baidu.com）

脚本会持续运行，建议通过 `screen` 或 `tmux` 后台运行

## utils.sh

Openwrt 备份脚本，注意自己调整备份文件保存的位置，建议使用 SMB 存储或者插个 U 盘

支持直接运行，用 `./utils.sh` 即可

也支持直接调用快速备份，加命令行参数即可

- `--owrt-backup` 备份整机系统配置（包括下面的这三个，是磁盘镜像）
- `--config-backup` 备份系统配置
- `--iptables-backup` 备份 iptables 的配置
- `--firewall-backup` 备份防火墙配置
- `--all-backup` 运行上面全部备份
