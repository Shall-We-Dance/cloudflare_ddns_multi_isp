# cloudflare_ddns_multi_isp

## 多ISP接入下的Cloudflare DDNS 自动更新脚本

[English](README.md)

在某些情况下，服务器会接入多个ISP的网络，获取多个**动态公网IP**地址，此脚本可使cloudflare**动态解析(DDNS)**多条A记录和AAAA记录。

我用于测试的服务器接入了电信和联通，因此有两个公网IPv4和IPv6地址。这也会是本脚本的默认情况。

## 前期工作

获取Cloudflare API。

## 使用方法

克隆本仓库。

```sh
git clone https://github.com/Shall-We-Dance/cloudflare_ddns_multi_isp.git
cd cloudflare_ddns_multi_isp
```