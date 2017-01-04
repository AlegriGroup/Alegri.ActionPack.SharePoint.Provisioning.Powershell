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
| AP_SPProvisioning_ClearLookupSiteColumnAfterProvisioning | Diese Aktion repariert das Schema von Lookup Site Column nach der Provisionierung. |
| AP_SPProvisioning_ClearLookupSiteColumnOnContentType | Bereinige die Referenz der LookUpSiteColumn innerhalb des Inhaltstyps |
| AP_SPProvisioning_ClearLookupSiteColumnOnList | Bereinige die Referenz der LookUpSiteColumn innerhalb der Liste |
| AP_SPProvisioning_ClearLookupSiteColumn | Anpassung der Schema XML der SiteColumn |
| AP_SPProvisioning_RemovedSiteColumn | Sie entfernen hiermit die SiteColumn von der aktuellen Website |
| AP_SPProvisioning_RemovedSiteColumnFromContentType | Sie entfernen hiermit SiteColumn von dem ContentType |

# AP_SPProvisioning_ClearLookupSiteColumnAfterProvisioning
## Beispiel Aktion XML
![image](https://github.com/Campergue/Alegri.ActionPack.SharePoint.Provisioning.Powershell/blob/master/AlegriActionPackSharePointProvisioning/AlegriActionPackSharePointProvisioning/Documentation/BeispielClearLookupSiteColumnAfterProvisioning.png)

## Attribute
| Attribute | Beschreibung | Verwendung |
| --- | --- | --- |
| pathToProvisioningXML | Der Pfad zur ProvisioningXML wo die SiteColumn enthalten sind. | required |

# AP_SPProvisioning_ClearLookupSiteColumnOnContentType
## Beispiel Aktion XML
![image](https://github.com/Campergue/Alegri.ActionPack.SharePoint.Provisioning.Powershell/blob/master/AlegriActionPackSharePointProvisioning/AlegriActionPackSharePointProvisioning/Documentation/BeispielClearLookupSiteColumnOnContentType.png)

## Attribute
| Attribute | Beschreibung | Verwendung |
| --- | --- | --- |
| ContentTypeName | Der ContentType wo die Spalte enthalten ist | required |
| FieldName | Die Lookup Spalte die angepasst werden soll | required |
| ListName | Die List Name für das Schema | required |

# AP_SPProvisioning_ClearLookupSiteColumnOnList
## Beispiel Aktion XML
![image](https://github.com/Campergue/Alegri.ActionPack.SharePoint.Provisioning.Powershell/blob/master/AlegriActionPackSharePointProvisioning/AlegriActionPackSharePointProvisioning/Documentation/BeispielClearLookupSiteColumnOnList.png)

## Attribute
| Attribute | Beschreibung | Verwendung |
| --- | --- | --- |
| ListNameFromField | Die Liste wo die Spalte enthält | required |
| FieldName | Die Lookup Spalte die angepasst werden soll | required |
| ListName | Die List Name für das Schema | required |

# AP_SPProvisioning_ClearLookupSiteColumn
## Beispiel Aktion XML
![image](https://github.com/Campergue/Alegri.ActionPack.SharePoint.Provisioning.Powershell/blob/master/AlegriActionPackSharePointProvisioning/AlegriActionPackSharePointProvisioning/Documentation/BeispielClearLookupSiteColumn.png)

## Attribute
| Attribute | Beschreibung | Verwendung |
| --- | --- | --- |
| FieldName | Die Lookup Spalte die angepasst werden soll | required |
| ListName | Die List Name für das Schema | required |

# AP_SPProvisioning_RemovedSiteColumn
## Beispiel Aktion XML
![image](https://github.com/Campergue/Alegri.ActionPack.SharePoint.Provisioning.Powershell/blob/master/AlegriActionPackSharePointProvisioning/AlegriActionPackSharePointProvisioning/Documentation/BeispielRemovedSiteColumn.png)

## Attribute
| Attribute | Beschreibung | Verwendung |
| --- | --- | --- |
| FieldName | Den Namen des SiteColumn das entfernt werden soll | optional |
| GroupName | Den Gruppennamen der SiteColumns die entfernt werden sollen. Bei der Verwendung des Gruppennamens wird die SiteColumn Namen, falls ebenfalls übergeben, ignoriert. | optional |

# AP_SPProvisioning_RemovedSiteColumnFromContentType
## Beispiel Aktion XML
![image](https://github.com/Campergue/Alegri.ActionPack.SharePoint.Provisioning.Powershell/blob/master/AlegriActionPackSharePointProvisioning/AlegriActionPackSharePointProvisioning/Documentation/BeispielRemovedSiteColumnFromContentType.png)

## Attribute
| Attribute | Beschreibung | Verwendung |
| --- | --- | --- |
| FieldName | Den Namen des SiteColumn das entfernt werden soll. Wenn Sie hier keinen Wert angeben werden alle SiteColumns vom ContentType entfernt | optional |
| ContentTypeName | Den Namen des ContentType wo die SiteColumn entfernt werden soll | required |
| DoNotUpdateChildren | Sollten Sie es nicht wünschen das die Veerbten ContentTypes mit Upgedatet werden, geben Sie hier bitte False ein. Default ist True | optional |

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
| AP_SPProvisioning_ClearLookupSiteColumnAfterProvisioning | This action repairs the Lookup SiteColumn Schema after the Provisioning |
| AP_SPProvisioning_ClearLookupSiteColumnOnContentType | Clean the reference of the LookUpSiteColumn within the ContentType |
| AP_SPProvisioning_ClearLookupSiteColumnOnList | Clean the reference of the LookUpSiteColumn within the list |
| AP_SPProvisioning_ClearLookupSiteColumn | Adapt the Schema XML from SiteColumn |
| AP_SPProvisioning_RemovedSiteColumn | You hereby remove the SiteColumn from the current Website |
| AP_SPProvisioning_RemovedSiteColumnFromContentType | This removes SiteColumn from the ContentType |

# AP_SPProvisioning_ClearLookupSiteColumnAfterProvisioning
## Example Action XML
![image](https://github.com/Campergue/Alegri.ActionPack.SharePoint.Provisioning.Powershell/blob/master/AlegriActionPackSharePointProvisioning/AlegriActionPackSharePointProvisioning/Documentation/BeispielClearLookupSiteColumnAfterProvisioning.png)

## Attributes
| Attributes | Description | Use |
| --- | --- | --- |
| pathToProvisioningXML | Der Pfad zur ProvisioningXML wo die SiteColumn enthalten sind. | required |

# AP_SPProvisioning_ClearLookupSiteColumnOnContentType
## Example Action XML
![image](https://github.com/Campergue/Alegri.ActionPack.SharePoint.Provisioning.Powershell/blob/master/AlegriActionPackSharePointProvisioning/AlegriActionPackSharePointProvisioning/Documentation/BeispielClearLookupSiteColumnOnContentType.png)

## Attributes
| Attribute | Description | Use |
| --- | --- | --- |
| ContentTypeName | The ContentType where the column is contained | required |
| FieldName | The lookup column to be customized | required |
| ListName | The List Name for the schema | required |

# AP_SPProvisioning_ClearLookupSiteColumnOnList
## Example Action XML
![image](https://github.com/Campergue/Alegri.ActionPack.SharePoint.Provisioning.Powershell/blob/master/AlegriActionPackSharePointProvisioning/AlegriActionPackSharePointProvisioning/Documentation/BeispielClearLookupSiteColumnOnList.png)

## Attributes
| Attribute | Description | Use |
| --- | --- | --- |
| ListNameFromField | The list where the column is contained | required |
| FieldName | The lookup column to be customized | required |
| ListName | The List Name for the schema | required |

# AP_SPProvisioning_ClearLookupSiteColumn
## Example Action XML
![image](https://github.com/Campergue/Alegri.ActionPack.SharePoint.Provisioning.Powershell/blob/master/AlegriActionPackSharePointProvisioning/AlegriActionPackSharePointProvisioning/Documentation/BeispielClearLookupSiteColumn.png)

## Attributes
| Attribute | Description | Use |
| --- | --- | --- |
| FieldName | The lookup column to be customized | required |
| ListName | The List Name for the schema | required |

# AP_SPProvisioning_RemovedSiteColumn
## Example Action XML
![image](https://github.com/Campergue/Alegri.ActionPack.SharePoint.Provisioning.Powershell/blob/master/AlegriActionPackSharePointProvisioning/AlegriActionPackSharePointProvisioning/Documentation/BeispielRemovedSiteColumn.png)

## Attribute
| Attribute | Description | Use |
| --- | --- | --- |
| FieldName | The name of the SiteColumn to remove | optional |
| GroupName | The group names of the SiteColumns to be removed. When you use the group name, the SiteColumn name is ignored, if passed. | optional |

# AP_SPProvisioning_RemovedSiteColumnFromContentType
## Example Action XML
![image](https://github.com/Campergue/Alegri.ActionPack.SharePoint.Provisioning.Powershell/blob/master/AlegriActionPackSharePointProvisioning/AlegriActionPackSharePointProvisioning/Documentation/BeispielRemovedSiteColumnFromContentType.png)

## Attribute
| Attribute | Description | Use |
| --- | --- | --- |
| FieldName | The name of the SiteColumn to remove. If you do not specify a value here, all SiteColumns are removed from the ContentType | optional |
| ContentTypeName |  The name of the ContentType where the SiteColumn should be removed | required |
| DoNotUpdateChildren | If you do not want the ContentTypes to be updated with Updated, please enter False. Default is true | optional |

