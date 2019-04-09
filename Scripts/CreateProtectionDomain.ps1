<#
.SYNOPSIS
	Create new protection domain for one virtual machine.

.PARAMETER vmName
	Virtual Machine name

.PARAMETER NutanixPrismElementsUrl
	Nutanix Prism Elements URI with https:// -prefix.

.PARAMETER UserName
	Nutanix Prism Elements username

.PARAMETER Password
	Nutanix Prism Elements password
	
.PARAMETER RemoteSite
	RemoteSite name

.EXAMPLE
	.\CreateProtectionDomain.ps1 -vmName "example" -NutanixPrismElementsUrl "https://1.2.3.4:9440" -Username "admin" -Password "password" -RemoteSite "datacenter2"
#>
param (
	[Parameter(Mandatory = $true)][string]$vmName,
	[Parameter(Mandatory = $true)][string]$NutanixPrismElementsUrl,
	[Parameter(Mandatory = $true)][string]$Username,
	[Parameter(Mandatory = $true)][string]$Password,
	[Parameter(Mandatory = $true)][string]$RemoteSite
)

# Use TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Disable certificate check
Add-Type -TypeDefinition @"
	using System.Net;
	using System.Security.Cryptography.X509Certificates;
	public class TrustAllCertsPolicy : ICertificatePolicy {
		public bool CheckValidationResult(
				ServicePoint srvPoint, X509Certificate certificate,
				WebRequest request, int certificateProblem) {
			return true;
		}
	}
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy

$AuthorizationBytes = [System.Text.Encoding]::UTF8.GetBytes($Username + ":" + $Password)
$AuthorizationBase64 = [System.Convert]::ToBase64String($AuthorizationBytes)
$NutanixAuthenticationHeaders = @{ Authorization = "Basic $AuthorizationBase64" }


# Create protection domain
$Item = New-Object -TypeName PSObject -Property @{
	"value" = $vmName
}
$Body = $Item | ConvertTo-Json -Depth 3 -Compress
Invoke-RestMethod -UseBasicParsing -Uri "$NutanixPrismElementsUrl/PrismGateway/services/rest/v2.0/protection_domains/" -Headers $NutanixAuthenticationHeaders  -Method POST -Body $Body -ContentType "application/json"


# Add VM to protection group
$Item = New-Object -TypeName PSObject -Property @{
	"app_consistent_snapshots" = $False
	"consistency_group_name" = $vmName
	"ignore_dup_or_missing_vms" = $True
	"names" = @(
		$vmName
	)
}
$Body = $Item | ConvertTo-Json -Depth 3 -Compress
Invoke-RestMethod -UseBasicParsing -Uri "$NutanixPrismElementsUrl/PrismGateway/services/rest/v2.0/protection_domains/$vmName/protect_vms" -Headers $NutanixAuthenticationHeaders  -Method POST -Body $Body -ContentType "application/json"

# Add schedule
$RemoteMaxSnapshots = New-Object -TypeName PSObject -Property @{
	$RemoteSite = 5
}
$RetentionPolicy = New-Object -TypeName PSObject -Property @{
	"local_max_snapshots" = 1
	"remote_max_snapshots" = $RemoteMaxSnapshots
}
$Item = New-Object -TypeName PSObject -Property @{
	"app_consistent" = $True
	"every_nth" = 2
	"pd_name" = $vmName
	"retention_policy" = $RetentionPolicy
	"type" = "HOURLY"
	"user_start_time_in_usecs" = [math]::floor((New-TimeSpan -Start (Get-Date "01/01/1970") -End (Get-Date)).TotalSeconds)
}
$Body = $Item | ConvertTo-Json -Depth 3 -Compress
Invoke-RestMethod -UseBasicParsing -Uri "$NutanixPrismElementsUrl/PrismGateway/services/rest/v2.0/protection_domains/$vmName/schedules" -Headers $NutanixAuthenticationHeaders  -Method POST -Body $Body -ContentType "application/json"
