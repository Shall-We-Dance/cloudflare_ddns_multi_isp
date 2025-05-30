#!/bin/bash

# A Cloudflare DDNS script for dual-ISP IPv4 and IPv6 support

# Cloudflare zone and DNS record
zone=example.com
dnsrecord=host.example.com

# Cloudflare API credentials and record IDs (fill with your actual values)
API_TOKEN="YOUR_CLOUDFLARE_API_TOKEN"
zoneid="YOUR_ZONE_ID"
dnsrecordid6="YOUR_AAAA_RECORD_ID"
dnsrecordid4_isp1="YOUR_IPV4_ISP1_RECORD_ID"
dnsrecordid4_isp2="YOUR_IPV4_ISP2_RECORD_ID"

# IP address source URLs (customize if needed)
IPV6_INFO_SOURCE="https://6.ipw.cn"
IPV4_INFO_SOURCE="http://myip.ipip.net"

# Get the current external IP addresses
ipv6=$(curl -s -X GET "$IPV6_INFO_SOURCE")
ipv4_isp1="0"
ipv4_isp2="0"

# Try up to 10 times to get both ISP IPv4s
for i in $(seq 1 10); do
  if [ "$ipv4_isp1" = "0" ] || [ "$ipv4_isp2" = "0" ]; then
    ipv4_temp=$(curl -s -X GET "$IPV4_INFO_SOURCE")
    echo "$ipv4_temp"

    if [ "$ipv4_isp1" = "0" ] && echo "$ipv4_temp" | grep "ISP1"; then
      ipv4_isp1=$(echo "$ipv4_temp" | awk '{print $2}' | awk -F"：" '{print $2}')
    fi
    if [ "$ipv4_isp2" = "0" ] && echo "$ipv4_temp" | grep "ISP2"; then
      ipv4_isp2=$(echo "$ipv4_temp" | awk '{print $2}' | awk -F"：" '{print $2}')
    fi
  fi
done

date
echo "Current IPv6 is $ipv6"
echo "Current ISP1 IPv4 is $ipv4_isp1"
echo "Current ISP2 IPv4 is $ipv4_isp2"

ipv6_no_change=0
ipv4_no_change=0

# Check if IPs are already set
if host $dnsrecord 1.1.1.1 | grep "address" | grep "$ipv6"; then
  echo "$dnsrecord IPv6 is currently set to $ipv6; no changes needed"
  ipv6_no_change=1
fi

if (host $dnsrecord 1.1.1.1 | grep "address" | grep "$ipv4_isp1") && \
   (host $dnsrecord 1.1.1.1 | grep "address" | grep "$ipv4_isp2"); then
  echo "$dnsrecord IPv4 is currently set to $ipv4_isp1 and $ipv4_isp2; no changes needed"
  ipv4_no_change=1
fi

# Update IPv6 record
if [ "$ipv6_no_change" -eq 0 ]; then
  curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$zoneid/dns_records/$dnsrecordid6" \
    -H "Authorization: Bearer ${API_TOKEN}" \
    -H "Content-Type: application/json" \
    --data "{\"type\":\"AAAA\",\"name\":\"$dnsrecord\",\"content\":\"$ipv6\",\"ttl\":1,\"proxied\":false}" | jq
fi

# Update IPv4 records
if [ "$ipv4_no_change" -eq 0 ]; then
  curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$zoneid/dns_records/$dnsrecordid4_isp1" \
    -H "Authorization: Bearer ${API_TOKEN}" \
    -H "Content-Type: application/json" \
    --data "{\"type\":\"A\",\"name\":\"$dnsrecord\",\"content\":\"$ipv4_isp1\",\"ttl\":1,\"proxied\":false}" | jq

  curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$zoneid/dns_records/$dnsrecordid4_isp2" \
    -H "Authorization: Bearer ${API_TOKEN}" \
    -H "Content-Type: application/json" \
    --data "{\"type\":\"A\",\"name\":\"$dnsrecord\",\"content\":\"$ipv4_isp2\",\"ttl\":1,\"proxied\":false}" | jq
fi
