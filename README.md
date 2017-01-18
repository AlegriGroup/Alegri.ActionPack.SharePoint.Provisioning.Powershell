# Alegri.ActionPack.SharePoint.Environment.Powershell
Ein Aktionspaket für das Provisionieren einer SharePoint Anwendung. Sie können es mit dem [Action Flow tool](https://github.com/Campergue/Alegri.ActionFlow.PowerShell.Commands) verwenden.
Die Aktionen sollen ihnen ermöglichen ganze SharePoint Anwendungen mit all seinen Artefakten durch reine XML Konfiguration zu Provisionieren.  

# Abhängigkeiten
Das Aktionspaket verwendet folgende fremde PowershellModule
- [PnP PowerShell Modul](https://github.com/SharePoint/PnP-PowerShell/tree/master/Documentation) ab Version 2.10.1612.0
- [Alegri.ActionPack.SharePoint.Environment.Powershell](https://github.com/Campergue/Alegri.ActionPack.SharePoint.Environment.Powershell)

## Hinweis
Alle abhängigen Funktionen sind gekapselt und werden nur aus der separaten Datei DependentFunction.ps1 verwendet. 
Wenn Sie die Abhängigkeit nicht möchten, könnten Sie theoretisch die Funktionen selber ausprogrammieren.

# Aktionen im Paket
Folgende Aktionen stehen Ihnen zur Verfügung.

| Aktion | Beschreibung |
| --- | --- |
| [AP_SPProvisioning_ClearLookupSiteColumnAfterProvisioning](https://github.com/Campergue/Alegri.ActionPack.SharePoint.Provisioning.Powershell/blob/master/Documentation/AP_SPProvisioning_ClearLookupSiteColumnAfterProvisioning.md) | Diese Aktion repariert das Schema von Lookup Site Column nach der Provisionierung. |
| [AP_SPProvisioning_ClearLookupSiteColumnOnContentType](https://github.com/Campergue/Alegri.ActionPack.SharePoint.Provisioning.Powershell/blob/master/Documentation/AP_SPProvisioning_ClearLookupSiteColumnOnContentType.md) | Bereinige die Referenz der LookUpSiteColumn innerhalb des Inhaltstyps |
| [AP_SPProvisioning_ClearLookupSiteColumnOnList](https://github.com/Campergue/Alegri.ActionPack.SharePoint.Provisioning.Powershell/blob/master/Documentation/AP_SPProvisioning_ClearLookupSiteColumnOnList.md) | Bereinige die Referenz der LookUpSiteColumn innerhalb der Liste |
| [AP_SPProvisioning_ClearLookupSiteColumn](https://github.com/Campergue/Alegri.ActionPack.SharePoint.Provisioning.Powershell/blob/master/Documentation/AP_SPProvisioning_ClearLookupSiteColumn.md) | Anpassung der Schema XML der SiteColumn |
| [AP_SPProvisioning_RemovedSiteColumn](https://github.com/Campergue/Alegri.ActionPack.SharePoint.Provisioning.Powershell/blob/master/Documentation/AP_SPProvisioning_RemovedSiteColumn.md) | Sie entfernen hiermit die SiteColumn von der aktuellen Website |
| [AP_SPProvisioning_RemovedSiteColumnFromContentType](https://github.com/Campergue/Alegri.ActionPack.SharePoint.Provisioning.Powershell/blob/master/Documentation/AP_SPProvisioning_RemovedSiteColumnFromContentType.md) | Sie entfernen hiermit SiteColumn von dem ContentType |
| [AP_SPProvisioning_PnPProvisioning](https://github.com/Campergue/Alegri.ActionPack.SharePoint.Provisioning.Powershell/blob/master/Documentation/AP_SPProvisioning_PnPProvisioning.md) | Hiermit wird die Provisionierung vom PnP Template durchgeführt. |
| [AP_SPProvisioning_GetProvisioningTemplate](https://github.com/Campergue/Alegri.ActionPack.SharePoint.Provisioning.Powershell/blob/master/Documentation/AP_SPProvisioning_GetProvisioningTemplate.md) | Hiermit wird die Provisionierung vom PnP Template durchgeführt. |
---

# Alegri.ActionPack.SharePoint.Environment.Powershell
An action pack for provisioning a SharePoint application. You can use it with the [Action Flow tool](https://github.com/Campergue/Alegri.ActionFlow.PowerShell.Commands).
The actions should allow them to provision entire SharePoint applications with all their artifacts through pure XML configuration.

# Dependencies
The action package uses the following strange Powershell modules
- [PnP PowerShell Modul](https://github.com/SharePoint/PnP-PowerShell/tree/master/Documentation) as of Version 2.10.1612.0
- [Alegri.ActionPack.SharePoint.Environment.Powershell](https://github.com/Campergue/Alegri.ActionPack.SharePoint.Environment.Powershell)

## Note
All dependent functions are encapsulated and are used only from the separate DependentFunction.ps1 file.
If you do not want the dependency, you could theoretically program the functions yourself.

# Actions in the package
The following actions are available.

| Action | Description |
| --- | --- |
| [AP_SPProvisioning_ClearLookupSiteColumnAfterProvisioning](https://github.com/Campergue/Alegri.ActionPack.SharePoint.Provisioning.Powershell/blob/master/Documentation/AP_SPProvisioning_ClearLookupSiteColumnAfterProvisioning.md) | This action repairs the Lookup SiteColumn Schema after the Provisioning |
| [AP_SPProvisioning_ClearLookupSiteColumnOnContentType](https://github.com/Campergue/Alegri.ActionPack.SharePoint.Provisioning.Powershell/blob/master/Documentation/AP_SPProvisioning_ClearLookupSiteColumnOnContentType.md) | Clean the reference of the LookUpSiteColumn within the ContentType |
| [AP_SPProvisioning_ClearLookupSiteColumnOnList](https://github.com/Campergue/Alegri.ActionPack.SharePoint.Provisioning.Powershell/blob/master/Documentation/AP_SPProvisioning_ClearLookupSiteColumnOnList.md) | Clean the reference of the LookUpSiteColumn within the list |
| [AP_SPProvisioning_ClearLookupSiteColumn](https://github.com/Campergue/Alegri.ActionPack.SharePoint.Provisioning.Powershell/blob/master/Documentation/AP_SPProvisioning_ClearLookupSiteColumn.md) | Adapt the Schema XML from SiteColumn |
| [AP_SPProvisioning_RemovedSiteColumn](https://github.com/Campergue/Alegri.ActionPack.SharePoint.Provisioning.Powershell/blob/master/Documentation/AP_SPProvisioning_RemovedSiteColumn.md) | You hereby remove the SiteColumn from the current Website |
| [AP_SPProvisioning_RemovedSiteColumnFromContentType](https://github.com/Campergue/Alegri.ActionPack.SharePoint.Provisioning.Powershell/blob/master/Documentation/AP_SPProvisioning_RemovedSiteColumnFromContentType.md) | This removes SiteColumn from the ContentType |
| [AP_SPProvisioning_PnPProvisioning](https://github.com/Campergue/Alegri.ActionPack.SharePoint.Provisioning.Powershell/blob/master/Documentation/AP_SPProvisioning_PnPProvisioning.md) | This provisioning is performed by PnP template. |
| [AP_SPProvisioning_GetProvisioningTemplate](https://github.com/Campergue/Alegri.ActionPack.SharePoint.Provisioning.Powershell/blob/master/Documentation/AP_SPProvisioning_GetProvisioningTemplate.md) | This creates a provisioning template from the current site |
