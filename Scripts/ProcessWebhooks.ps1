param (
    $Data
)
$Request = $Data | ConvertFrom-Json
$TempFolder = [System.IO.Path]::GetTempPath()
$LogFile = $TempFolder + "WebhookToPowershell.log"

switch ($Request.event_type) {
	"VM.CREATE" {
		& $PSScriptRoot\vmCREATE.ps1 -Request $Request -LogFile $LogFile
	}
	"VM.DELETE" {
		& $PSScriptRoot\vmDELETE.ps1 -Request $Request -LogFile $LogFile
	}
	"VM.UPDATE" {
		& $PSScriptRoot\vmUPDATE.ps1 -Request $Request -LogFile $LogFile
	}
	"VM.ON" {
		& $PSScriptRoot\vmON.ps1 -Request $Request -LogFile $LogFile
	}
	"VM.OFF" {
		& $PSScriptRoot\vmOFF.ps1 -Request $Request -LogFile $LogFile
	}
	"VM.MIGRATE" {
		& $PSScriptRoot\vmMIGRATE.ps1 -Request $Request -LogFile $LogFile
	}
	default {
		"$(Get-Date -Format u) - event type `"$($Request.event_type)`" is not supported" | Out-File -FilePath $LogFile -Append
	}
}
