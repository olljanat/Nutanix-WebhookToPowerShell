$TempFolder = [System.IO.Path]::GetTempPath()
$Folder = $TempFolder + "WebhookToPowerShell"
$ArchiveFolder = $TempFolder + "WebhookToPowerShell\Archive"

If (Test-Path -Path $Folder) {
    If (!(Test-Path -Path $ArchiveFolder)) {
        New-Item -ItemType Directory -Path $ArchiveFolder
    }

    $Files = Get-ChildItem -Path $Folder
    ForEach($File in $Files) {
        ##### Add actual processing logic here #####

        Move-Item -Path $File.FullName -Destination "$ArchiveFolder\$($File.Name)"
    }
}