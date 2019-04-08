param (
    [object]$Request,
	[string]$LogFile
)
[string]$vmName = $Request.data.metadata.spec.name
"$(Get-Date -Format u) - New virtual machine `"$vmName`" was created" | Out-File -FilePath $LogFile -Append
