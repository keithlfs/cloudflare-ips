Param( 
    [Parameter(Mandatory = $true)] 
    [string] $ResourceGroupName, 
    [Parameter(Mandatory = $true)] 
    [string] $AppServiceName
)

$ErrorActionPreference = "Stop"

## Deprecated IP support
## Add to this list any existing IPs that you want removed
$deprecatedIps = @("104.16.0.0/12")

# Fetch Cloudflare IPs and current App Service IP configuration
$IPv4s = (Invoke-WebRequest -Uri "https://www.cloudflare.com/ips-v4").Content.TrimEnd([Environment]::NewLine).Split([Environment]::NewLine);
$IPv6s = (Invoke-WebRequest -Uri "https://www.cloudflare.com/ips-v6").Content.TrimEnd([Environment]::NewLine).Split([Environment]::NewLine);
$currentConfig = Get-AzWebAppAccessRestrictionConfig -ResourceGroupName $ResourceGroupName -Name $AppServiceName

# Write some debug info
Write-Host "Loaded $($IPv4s.Count) Cloudflare IPv4 IPs"
Write-Host "Loaded $($IPv6s.Count) Cloudflare IPv6 IPs"
Write-Host "Loaded $($currentConfig.MainSiteAccessRestrictions.Count) existing IPs"
Write-Host "Loaded $($deprecatedIps.Count) deprecated IPs"

# Process IPv4
foreach($IPv4 in $IPv4s){
    
    $apply = $true
    foreach ($existingIp in $currentConfig.MainSiteAccessRestrictions) {
        if ($existingIp.IpAddress -eq $IPv4) {
            $apply = $false
        }
    }

    if ($apply) {
        Write-Host "Adding $IPv4 in $ResourceGroupName to $AppServiceName"
        Add-AzWebAppAccessRestrictionRule -IpAddress $IPv4 -ResourceGroupName $ResourceGroupName -WebAppName $AppServiceName -Priority 1000 -Name "Cloudflare IPv4"
        Add-AzWebAppAccessRestrictionRule -IpAddress $IPv4 -ResourceGroupName $ResourceGroupName -WebAppName $AppServiceName -Priority 1000 -Name "Cloudflare IPv4" -SlotName "staging"
    } else {
        Write-Host "Skipping IP $IPv4 (already exists)"
    }
}

# Process Ipv6
foreach($IPv6 in $IPv6s){
    $apply = $true
    foreach ($existingIp in $currentConfig.MainSiteAccessRestrictions) {
        if ($existingIp.IpAddress -eq $IPv6) {
            $apply = $false
        }
    }
    
    if ($apply) {
        Write-Host "Adding $IPv6 in $ResourceGroupName to $AppServiceName"
        Add-AzWebAppAccessRestrictionRule -IpAddress $IPv6 -ResourceGroupName $ResourceGroupName -WebAppName $AppServiceName -Priority 1000 -Name "Cloudflare IPv6"
        Add-AzWebAppAccessRestrictionRule -IpAddress $IPv6 -ResourceGroupName $ResourceGroupName -WebAppName $AppServiceName -Priority 1000 -Name "Cloudflare IPv6" -SlotName "staging"
    } else {
        Write-Host "Skipping IP $IPv6 (already exists)"
    }
}

# try to remove any deprecated IPs from the current configuration
foreach ($deprecatedIp in $deprecatedIps) {
    foreach ($ip in $currentConfig.MainSiteAccessRestrictions) {
        if ($deprecatedIp -ne "" -and $ip.IpAddress -eq $deprecatedIp) {
            $oldIp = $ip.IpAddress
            Write-Host "Removing old IP address: $oldIp"
            Remove-AzWebAppAccessRestrictionRule -IpAddress $oldIp -ResourceGroupName $ResourceGroupName -WebAppName $AppServiceName
            Remove-AzWebAppAccessRestrictionRule -IpAddress $oldIp -ResourceGroupName $ResourceGroupName -WebAppName $AppServiceName -SlotName "staging"
        }
    }
}

Write-Host "All done"