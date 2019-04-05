param (
    $Data
)

$TempFolder = [System.IO.Path]::GetTempPath()
$ArchiveFolder = $TempFolder + "WebhookToPowerShell"
If (!(Test-Path -Path $ArchiveFolder)) {
    New-Item -ItemType Directory -Path $ArchiveFolder
}
$ArchiveFile = $ArchiveFolder + "\" + (New-Guid).Guid + ".json"
$Data | Out-File $ArchiveFile
