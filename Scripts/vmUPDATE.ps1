param (
    [object]$Request,
	[string]$LogFile
)
[string]$vmName = $Request.data.metadata.spec.name
"$(Get-Date -Format u) - Virtual machine `"$vmName`" was updated" | Out-File -FilePath $LogFile -Append
