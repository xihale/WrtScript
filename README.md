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

## ipv4.sh

用来通过 Cloudflare 绑定的域名进行内网 DDNS 的脚本，目的是为了在大内网的其他地方也能够访问到内网的设备

需要自己调整 Cloudflare 的相关内容

```bash
# Cloudflare API 相关信息
# Cloudflare API 端点，替换为实际的 API URL
CF_API=""
# Cloudflare API Token，换成你自己的
CF_TOKEN=""
# Cloudflare 域名，换成你自己的，这个是你要访问的域名
CF_DOMAIN=""
```

平时使用直接 `./ipv4.sh` 运行就行

## ping.sh

通过对网关进行 ping 操作来判断机身是否断开 pppoe 连接，需要与 `generate_mac.sh` 和 `ipv4.sh` 一起使用（DDNS 脚本不用的话注释掉就行）

建议开机运行

## swap.sh

调整机身的 swap 分区的脚本，避免因软路由自身内存限制导致很多软件无法运行

直接 `./swap.sh` 运行就行

## utils.sh

Openwrt 备份脚本，注意自己调整备份文件保存的位置，建议使用 SMB 存储或者插个 U 盘

支持直接运行，用 `./utils.sh` 即可

也支持直接调用快速备份，加命令行参数即可

- `--owrt-backup` 备份整机系统配置（包括下面的这三个，是磁盘镜像）
- `--config-backup` 备份系统配置
- `--iptables-backup` 备份 iptables 的配置
- `--firewall-backup` 备份防火墙配置
- `--all-backup` 运行上面全部备份
