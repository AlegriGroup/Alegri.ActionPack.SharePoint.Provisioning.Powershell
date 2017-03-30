$Global:ActionPackageName = "SharePoint Provisioning"

. "$PSScriptRoot\PSScripts\AP_SPProvisioning.ps1"

Write-Host "Alegri Action Package $($Global:ActionPackageName) are ready" -ForegroundColor Green

#If you want to create default folders for your action package, please comment on the section
#Kommentieren Sie den Bereich ein, wenn Sie vor haben für Ihr Aktionspaket Standard Ordner anzulegen 
Check-ExistFolderInAP_SPProvisioning #AP_SPProvisioning