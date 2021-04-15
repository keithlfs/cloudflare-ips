# Maintain Azure App Service Cloudflare IP's
Dynamically maintains the whitelist of Cloudflare IP addresses for the specified Azure App Service. Optionally removes any specified deprecated/old IP restriction rules. Also attempts to make the same changes to the slot named 'staging' at the same time. 

## Usage
.\AddCloudflareIPs.ps1 -ResourceGroupName your-resource-group-name -AppServiceName your-app-service-name

## Example
```
.\AddCloudflareIPs.ps1 -ResourceGroupName foogroup -AppServiceName barservice
Loaded 15 Cloudflare IPv4 IPs
Loaded 7 Cloudflare IPv6 IPs
Loaded 24 existing IPs
Loaded 1 deprecated IPs
Skipping IP 173.245.48.0/20 (already exists)
Skipping IP 103.21.244.0/22 (already exists)
Skipping IP 103.22.200.0/22 (already exists)
Skipping IP 103.31.4.0/22 (already exists)
Skipping IP 141.101.64.0/18 (already exists)
Skipping IP 108.162.192.0/18 (already exists)
Skipping IP 190.93.240.0/20 (already exists)
Skipping IP 188.114.96.0/20 (already exists)
Skipping IP 197.234.240.0/22 (already exists)
Skipping IP 198.41.128.0/17 (already exists)
Skipping IP 162.158.0.0/15 (already exists)
Skipping IP 172.64.0.0/13 (already exists)
Skipping IP 131.0.72.0/22 (already exists)
Adding 104.16.0.0/13 in foogroup to barservice
Adding 104.24.0.0/14 in foogroup to barservice
Skipping IP 2400:cb00::/32 (already exists)
Skipping IP 2606:4700::/32 (already exists)
Skipping IP 2803:f800::/32 (already exists)
Skipping IP 2405:b500::/32 (already exists)
Skipping IP 2405:8100::/32 (already exists)
Skipping IP 2a06:98c0::/29 (already exists)
Skipping IP 2c0f:f248::/32 (already exists)
Removing old IP address: 104.16.0.0/12
All done
```
