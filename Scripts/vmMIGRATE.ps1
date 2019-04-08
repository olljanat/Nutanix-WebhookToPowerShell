param (
    [object]$Request,
	[string]$LogFile
)
[string]$vmName = $Request.data.metadata.spec.name
[string]$hypervisorHost = $Request.data.metadata.status.resources.host_reference.name
"$(Get-Date -Format u) - Virtual machine `"$vmName`" was migrated to host `"$hypervisorHost`"" | Out-File -FilePath $LogFile -Append
