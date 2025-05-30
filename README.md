# Cloudflare DDNS Updater with Dual-ISP IPv4 & IPv6 Support

[中文](README_zh.md)

This Bash script automatically updates a Cloudflare DNS record with your current public IP addresses, including support for:

- **IPv6**
- **Dual IPv4 addresses from two ISPs (ISP1 and ISP2)**

It is intended for home servers or self-hosted services using Cloudflare for DNS and having multiple external IPs (e.g., from dual-WAN routers or multiple broadband providers).

## ✨ Features

- Supports both `A` (IPv4) and `AAAA` (IPv6) records.
- Supports two distinct IPv4 addresses (e.g., dual ISP environments).
- Works with dynamic IP addresses.
- Simple and easily customizable.

## ⚙️ Requirements

- A **Cloudflare API token** with DNS edit permissions.
- Pre-existing DNS records in Cloudflare (one AAAA and two A records).
- `curl`, `jq`, and `host` command-line tools installed.

## 🛠️ Configuration

Edit the script variables:

```bash
API_TOKEN="your_cloudflare_api_token"
zoneid="your_zone_id"
dnsrecord="your.full.domain.com"

dnsrecordid6="record_id_for_AAAA"
dnsrecordid4_isp1="record_id_for_ISP1_IPv4"
dnsrecordid4_isp2="record_id_for_ISP2_IPv4"
````

Set IP information source URLs (optional):

```bash
IPV6_INFO_SOURCE="https://6.ipw.cn"
IPV4_INFO_SOURCE="http://myip.ipip.net"
```

Update ISP keywords in the script (`ISP1`, `ISP2`) to match your actual provider labels (e.g., "China Telecom", "China Unicom").

## 🚀 Usage

Make the script executable and run:

```bash
chmod +x ddns-update.sh
./ddns-update.sh
```

You can add it to a cron job for automatic updates:

```bash
crontab -e
# Run every 10 minutes
*/10 * * * * /path/to/ddns-update.sh
```

## 🔐 Security Notes

* **Do not share your API token or zone ID.**
* Consider storing sensitive values in environment variables or a `.env` file and loading them in the script.

## 🧾 License

MIT License.
