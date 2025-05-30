# 多ISP接入下的Cloudflare DDNS 自动更新脚本（支持双 ISP IPv4 和 IPv6）

[English](README.md)

在某些情况下，服务器会接入多个ISP的网络，获取多个**动态公网IP**地址，该 Bash 脚本可自动将当前公网 IP 地址更新到 Cloudflare DNS 中，支持：

- **IPv6 地址**
- **两个不同运营商的 IPv4 地址（例如电信 + 联通）**

适用于使用 Cloudflare 作为 DNS 服务、自建服务器或家庭宽带双拨号（双 WAN）等场景。

## ✨ 特性

- 同时更新 `A`（IPv4）和 `AAAA`（IPv6）记录
- 支持双 ISP 的两个 IPv4 地址
- 支持公网动态 IP
- 脚本结构简单，易于扩展

## ⚙️ 使用要求

- 一个具有 DNS 编辑权限的 **Cloudflare API Token**
- 在 Cloudflare 中预先创建好相应的 DNS 记录（1 个 AAAA，2 个 A）
- 系统安装了 `curl`、`jq`、`host` 工具

## 🛠️ 配置方式

编辑脚本中的如下变量：

```bash
API_TOKEN="你的 Cloudflare API Token"
zoneid="你的域名 Zone ID"
dnsrecord="你的完整域名"

dnsrecordid6="AAAA 记录的 ID"
dnsrecordid4_isp1="第一个 IPv4（ISP1）记录的 ID"
dnsrecordid4_isp2="第二个 IPv4（ISP2）记录的 ID"
````

也可以修改 IP 查询源（如需更换）：

```bash
IPV6_INFO_SOURCE="https://6.ipw.cn"
IPV4_INFO_SOURCE="http://myip.ipip.net"
```

根据你网络环境，将脚本中 `ISP1`、`ISP2` 替换为实际的运营商标识（如 “电信”、“联通”）。

## 🚀 使用方法

给脚本加执行权限并运行：

```bash
chmod +x ddns-update.sh
./ddns-update.sh
```

加入计划任务定时运行：

```bash
crontab -e
# 每 10 分钟运行一次
*/10 * * * * /path/to/ddns-update.sh
```

## 🔐 安全建议

* **请勿公开 API Token、zone ID 等敏感信息**
* 可将敏感信息写入 `.env` 文件并在脚本中引用，提升安全性

## 🧾 License

MIT 许可协议
