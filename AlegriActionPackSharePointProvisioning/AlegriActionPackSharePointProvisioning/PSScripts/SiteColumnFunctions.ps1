#
# SiteColumnFunctions.ps1
#

function Start-AP_SPProvisioning_RemovedSiteColumn
{
	<#
	.Synopsis
	Start AP_SPProvisioning_RemovedSiteColumn
	.DESCRIPTION
	The Start for the Action AP_SPProvisioning_RemovedSiteColumn
	.PARAMETER xmlActionObject
	#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=0)]
        [System.Xml.XmlLinkedNode]$xmlActionObject
	)
    Begin
    {
		Write-Verbose "Start Start-AP_SPProvisioning_RemovedSiteColumn"
    }
    Process
    {	
		$field_name = $null;
		$group_name = $null;
		$currentWeb = Get-AP_SPProvisioning_SPEnvironment_CurrentWeb

		if($xmlActionObject.FieldName) { $field_name = $xmlActionObject.FieldName}
		if($xmlActionObject.GroupName) { $group_name = $xmlActionObject.GroupName}

		if($field_name -eq $null -and $group_name -eq $null)
		{
			Write-Error "Missing attributes. At least one of the attributes [FieldName or GroupName] must be passed"
		} 
		else 
		{
			Select-AP_SPProvisioning_SiteColumn -Web $currentWeb.Web -FieldName $field_name -GroupName $group_name
		}
    }
    End
    {
		Write-Verbose "End Start-AP_SPProvisioning_RemovedSiteColumn"
    }
}

function Start-AP_SPProvisioning_RemovedSiteColumnFromContentType
{
	<#
	.Synopsis
	Start AP_SPProvisioning_RemovedSiteColumnFromContentType
	.DESCRIPTION
	The Start for the Action AP_SPProvisioning_RemovedSiteColumnFromContentType
	.PARAMETER xmlActionObject
	#>
	[CmdletBinding()]
	param
	(
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=0)]
        [System.Xml.XmlLinkedNode]$xmlActionObject
	)
	begin
	{
		Write-Verbose "Start-AP_SPProvisioning_RemovedSiteColumnFromContentType begin"
	}
	process
	{
		$currentWeb = Get-AP_SPProvisioning_SPEnvironment_CurrentWeb
		$contentType_name = $xmlActionObject.ContentTypeName
		$doNotUpdateChildren = $true

		$field_name = $null 		
		if($xmlActionObject.FieldName) { $field_name = $xmlActionObject.FieldName }
		if($xmlActionObject.DoNotUpdateChildren -and $xmlActionObject.DoNotUpdateChildren -eq "false") { $doNotUpdateChildren = $false }

		if($contentType_name -eq $null)
		{
			Write-Error "Missing attributes. The attributes [ContentTypeName] are required"	
		} 
		else 
		{
			$contentType = Use-AP_SPProvisioning_PnP_Get-PnPContentType -Web $currentWeb.Web -Identity $contentType_name

			if($contentType -ne $null)
			{
				if($field_name -eq $null)
				{
					Remove-SPProvisioning_AllSiteColumnsFromContentType -Web $currentWeb.Web -ContentType $contentType -DoNotUpdateChildren $doNotUpdateChildren
				}
				else
				{
					Remove-SPProvisioning_SiteColumnFromContentType -Web $currentWeb.Web -ContentType $contentType -FieldName $field_name -DoNotUpdateChildren $doNotUpdateChildren
				}
			}
			else
			{
				Write-Host "The ContentType $($contentType_name) are not founded" -ForegroundColor Red
			}				
			
		}				
	}
	end
	{
		Write-Verbose "Start-AP_SPProvisioning_RemovedSiteColumnFromContentType end"
	}
}

function Start-AP_SPProvisioning_SetSiteColumnDisplayName
{
	[CmdletBinding()]
	param
	(
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=0)]
        [System.Xml.XmlLinkedNode]$xmlActionObject
	)
	begin
	{
		Write-Verbose "Start-AP_SPProvisioning_SetSiteColumnDisplayName begin"
	}
	process
	{
		$xmlFilePath = Use-AP_SPProvisioning_SPEnvironment_Check-ReplaceProjectPath -path $xmlActionObject.pathToProvisioningXML
		$currentWeb = Get-AP_SPProvisioning_SPEnvironment_CurrentWeb

		[xml]$content = Get-Content -Path $xmlFilePath -Encoding UTF8
		$siteFields = $content.Provisioning.Templates.ProvisioningTemplate.SiteFields.Field

		foreach($siteField in $siteFields)
		{
			$currentField = Use-AP_SPProvisioning_PnP_Get-PnPField -Web $currentWeb.Web -Identity $siteField.ID
            
            if($currentField.Title -ne $siteField.DisplayName) 
            {
                $currentField.Title = $siteField.DisplayName
                $currentField.Update()
                $currentField.Context.ExecuteQuery()
                Write-Host "Spalte $($siteField.Name) zu $($siteField.DisplayName) geändert"
            }
		}
	}
	end
	{
		Write-Verbose "Start-AP_SPProvisioning_SetSiteColumnDisplayName end"
	}
}

function Select-AP_SPProvisioning_SiteColumn
{
	<# 
	.SYNOPSIS
	Checks whether a SiteColumn or Groups should be deleted
	Pr�ft ob eine SiteColumn oder Gruppen gel�scht werden sollen
    .DESCRIPTION
	If you have specified a field name, it is deleted. If you specify a group name, all SiteColumns in the group will be removed and the FieldName will be passed if it is also present.
    Wenn Sie einen Fieldname angegeben haben, wird dieser gel�scht. Wenn Sie eine Gruppenamen angeben, werde alle SiteColumns in der Gruppe entfernt und der FieldName wird �bergangen, sollte dieser ebenfalls vorhanden sein.
	.PARAMETER Web
	The Current Web Object 
	Das Aktuelle Web Objekt
	.PARAMETER FieldName
	The name of the SiteColumn to remove
    Den Namen des SiteColumn das entfernt werden soll
	.PARAMETER GroupName
	The group names of the SiteColumns to be removed.
    Den Gruppennamen der SiteColumns die entfernt werden sollen. 
	#>
	[CmdletBinding()]
	param(
		[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
		[ValidateNotNullOrEmpty()]
		$Web,
		$FieldName,
		$GroupName
	)
	begin
	{
		Write-Verbose "Remove-AP_SPProvisioning_SiteColumn begin"
	}
	process
	{
		if($GroupName -ne $null)
		{
			Remove-SPProvisioning_AllSiteColumnFromGroup -Groupname $GroupName -Web $Web

			Write-Host "Successfully removed site colums from the group $($GroupName) on current web" -Type success
			Write-Host
		} 
		elseif ($FieldName -ne $null)
		{
			$siteColumns = Use-AP_SPProvisioning_PnP_Get-PnPField -Web $Web
			$siteColumn = Use-AP_SPProvisioning_PnP_Get-PnPField -Web $Web -Identity $FieldName

			$siteColumsToDelete = Find-SPProvisioning_SiteColumnReferenz -SiteColumns $siteColumns -SiteColumn $siteColumn

			Remove-SPProvisioning_SiteColumn -siteFields $siteColumsToDelete -Web $Web
			Write-Host "Successfully removed site colums from $($FieldName) on current web" -Type success
			Write-Host
		}
		else
		{
			Write-Error "Missing attributes. At least one of the attributes [FieldName or GroupName] must be passed"
		}				
	}
	end
	{
		Write-Verbose "Remove-AP_SPProvisioning_SiteColumn end"
	}
}

function Remove-SPProvisioning_AllSiteColumnFromGroup
{
	<# 
	.SYNOPSIS
	Removes all SiteColumns belonging to the group
	Entfernt alle SiteColumn die der Gruppe angeh�ren	
    .DESCRIPTION
	Removes all SiteColumns belonging to the group
    Entfernt alle SiteColumn die der Gruppe angeh�ren
    .PARAMETER Groupname
	The Name of the Group 
    Der Name der Gruppe
	.PARAMETER Web
	The Current Web Object
	Das Aktuelle Web Objekt
	#>
	[CmdletBinding()]
	param(
	[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
	[ValidateNotNullOrEmpty()]
    $Groupname,
	[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
	[ValidateNotNullOrEmpty()]
    $Web
	)
	begin
	{
		Write-Verbose "Remove-SPProvisioning_AllSiteColumnFromGroup begin"
	}
	process
	{
		Write-Host "START RemoveSiteColumn from Group $($Groupname)"

		$siteFields = Use-AP_SPProvisioning_PnP_Get-PnPField -Web $Web | ? { $_.Group -eq $Groupname }
		
		$siteFieldWithOutReferenz = $siteFields | ? { $_.InternalName -notlike "*_x003A*" }
		
        foreach($siteField in $siteFieldWithOutReferenz) 
		{
			$siteColumnsToDelete = Find-SPProvisioning_SiteColumnReferenz -SiteColumns $siteFields -SiteColumn $siteField			
			Remove-SPProvisioning_SiteColumn -siteFields $siteColumnsToDelete -Web $Web
		}
		
		if($siteFields -eq $null)
		{
			Write-Host "There is no SiteColumn in the group to delete" -ForegroundColor Yellow
		}

		Write-Host "END RemoveSiteColumn from Group $($Groupname)"
	}
	end
	{
		Write-Verbose "Remove-SPProvisioning_AllSiteColumnFromGroup end"
	}
}

function Find-SPProvisioning_SiteColumnReferenz
{
	<# 
	.SYNOPSIS
	Es wird gepr�ft ob es Abh�ngigkeiten zu der SiteColumn gibt	
    .DESCRIPTION
	Es wird gepr�ft ob es Abh�ngigkeiten zu der SiteColumn gibt. Wenn ja werden diese zuerst in das Array gef�llt.
	Danach die Spalte selbst. Somit k�nnen Sie zuerst die Abh�ngigen Spalten l�schen und danach die Hauptspalte.
    .PARAMETER SiteColumns
	Ein Array mit allen SiteColumns zu �berpr�fen
	.PARAMETER SiteColumn
	Die SiteColumn die nach Abh�ngigkeit �berpr�ft werden soll
	.OUTPUT Array
	Ein Array mit allen SiteColumns
	#>
	[CmdletBinding()]
	param(
	[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
	[ValidateNotNullOrEmpty()]
    $SiteColumns,
	[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
	[ValidateNotNullOrEmpty()]
    $SiteColumn
	)
	begin
	{
		Write-Verbose "Find-SPProvisioning_SiteColumnReferenz begin"
	}
	process
	{
		$returnArray = @()

		$siteFieldWithReferenzs = $SiteColumns | ? { $_.InternalName -like "$($SiteColumn.InternalName)_x003A*" }
            
        foreach($siteFieldWithReferenz in $siteFieldWithReferenzs) 
        {
			$returnArray += $siteFieldWithReferenz
        }

		$returnArray += $SiteColumn

		return $returnArray
	}
	end
	{
		Write-Verbose "Find-SPProvisioning_SiteColumnReferenz end"
	}
}

function Remove-SPProvisioning_SiteColumn
{
	<# 
	.SYNOPSIS
	Removes the SiteColumn from the current site
    Entfernt die SiteColumn von der aktuellen Web Seite
    .DESCRIPTION
    Entfernt die SiteColumn von der aktuellen Web Seite
    .PARAMETER Groupname 
    Der Name der Gruppe
	.PARAMETER Web
	The Current Web Object
	Das Aktuelle Web Objekt
	#>
	[CmdletBinding()]
	param(
	[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
	[ValidateNotNullOrEmpty()]
    $siteFields,
	[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
	[ValidateNotNullOrEmpty()]
    $Web
	)
	begin
	{
		Write-Verbose "Remove-SPProvisioning_SiteColumn begin"
	}
	process
	{  
		foreach($siteField in $siteFields)
		{
			try 
			{
				Use-AP_SPProvisioning_PnP_Remove-PnPField -Identity $siteField -Web $Web -Force $true
				Write-Host "Deleted Site Column $($siteField.InternalName)" -ForegroundColor Green               
			}
			catch
			{
				Write-Host "Could not delete Site Column $($siteField.InternalName)" -ForegroundColor Red
			}		
		}
	}
	end
	{
		Write-Verbose "Remove-SPProvisioning_SiteColumn end"
	}
}

function Remove-SPProvisioning_AllSiteColumnsFromContentType
{
	<# 
	.SYNOPSIS
    Entfernt alle SiteColumns am ContentType
    .DESCRIPTION
    Es werden alle SiteColumns vom ContentTypes geladen und dann entsprechend entfernt
    .PARAMETER Web 
    Das Aktuelle Web Objekt
	.PARAMETER ContentType
	Das ContentType Objekt wo die SiteColumns entfernt werden sollen
	#>
	[CmdletBinding()]
	param(
	[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
	[ValidateNotNullOrEmpty()]
    $Web,
	$ContentType,
	$DoNotUpdateChildren
	)
	begin
	{
		Write-Verbose "RemoveSiteColumnsFromContentTypes begin"
	}
	process
	{
		$ContentType.Context.Load($ContentType.Fields)
		$ContentType.Context.ExecuteQuery()
        
        $fields = $ContentType.Fields | Where-Object {$_.CanBeDeleted -eq $True -and $_.InternalName -notlike "*_x003A*"}

        foreach($field in $fields)
        {
			Remove-SPProvisioning_SiteColumnFromContentType -Web $Web -ContentType $ContentType -FieldName $field.InternalName -DoNotUpdateChildren $DoNotUpdateChildren
		}
	}
	end
	{
		Write-Verbose "RemoveSiteColumnsFromContentTypes end"
	}
}

function Remove-SPProvisioning_SiteColumnFromContentType
{
	<# 
	.SYNOPSIS
	Removes the SiteColumns on the ContentType
    Entfernt das SiteColumns am ContentType
    .DESCRIPTION
	It removes the SiteColumns from the ContentTypes
    Es wird das SiteColumns vom ContentTypes entfernt
    .PARAMETER Web 
	The Current Web Object
    Das Aktuelle Web Objekt
	.PARAMETER ContentType
	The ContentType object where the SiteColumns are to be removed
	Das ContentType Objekt wo die SiteColumns entfernt werden sollen
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
		[ValidateNotNullOrEmpty()]
		$Web,
		$ContentType,
		$FieldName,
		$DoNotUpdateChildren
	)
	begin
	{
		Write-Verbose "Remove-SPProvisioning_SiteColumnFromContentType begin"
	}
	process
	{
		Write-Host "Start Remove SiteColumnFromContentType for Field $($FieldName)" -ForegroundColor Yellow
		Use-AP_SPProvisioning_PnP_Remove-PnPFieldFromContentType -Field $FieldName -ContentType	$ContentType -DoNotUpdateChildren $DoNotUpdateChildren
	}
	end
	{
		Write-Verbose "Remove-SPProvisioning_SiteColumnFromContentType end"
	}
}

function Remove-FieldsFromListsCorrectly
{
	<# 
	.SYNOPSIS
	Entfernt die SiteColumn von der Liste
    .DESCRIPTION
    Es werden auf allen �bergebenen Listen die verwendete SiteColumn im Projekt aus der Liste entfernt
    .PARAMETER arrayLists
    Die Liste auf dennen die SiteColumn entfernt werden sollen.
	#>
	[CmdletBinding()]
	param(
	[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
	[ValidateNotNullOrEmpty()]
    $arrayLists,
	[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
	$arraySiteColumn
	)
	begin
	{
		Write-Verbose "RemoveFieldsFromLists begin"
	}
	process
	{
		Write-Host "START RemoveFieldsFromLists"

		foreach($liste in $arrayLists)
		{   
			Write-Host "Removing fields from List $liste"
             
			$currentWeb = Get-AP_SPProvisioning_SPEnvironment_CurrentWeb
			$list = Use-AP_SPProvisioning_PnP_Get-PnPList -Identity $liste -Web $currentWeb.Web

			if($list)
			{
				$list.Context.Load($list.Fields)
				$list.Context.ExecuteQuery()
                
                $sortedFields = $list.Fields | Sort-Object  -Property "InternalName" -Descending
                
				$fieldsReferenz = $sortedFields |  Where-Object {$_.InternalName -match "x003A" }
				$fieldNormal = $sortedFields |  Where-Object {$_.InternalName -notmatch "x003A" }
				
				#Erst die Felder mit Referenz				    
				for ($i = 0; $i -lt $fieldsReferenz.Count; $i++)         
				{
					$field = $fieldsReferenz[$i]
					if($arraySiteColumn -contains $field.InternalName)
					{
						Use-AP_SPProvisioning_PnP_Remove-PnPField -Web $currentWeb.Web -List $list -Identity $field.InternalName -Force $true                     
						Write-Host "Deleted field $($field.InternalName) from list" -Type success
					}
                    
				}

				#Danach die Felder ohne Referenz
				for ($i = 0; $i -lt $fieldNormal.Count; $i++)         
				{
					$field = $fieldNormal[$i]
					if($arraySiteColumn -contains $field.InternalName)
					{
						Use-AP_SPProvisioning_PnP_Remove-PnPField -Web $currentWeb.Web -List $list -Identity $field.InternalName -Force $true                     
						Write-Host "Deleted field $($field.InternalName) from list" -Type success
					}                    
				}

                $list.Context.ExecuteQuery()
			}
			else 
			{
				$text = "ERROR Deleted field from list $liste because List not found"
				Write-Host $text -Type error
				$text = $text + "Soll das Skript weiter machen?"
				Create-QuestionTask -statement $text
			}
		}
	}
	end
	{
		Write-Verbose "RemoveFieldsFromLists end"
	}
}

#TODO
# Funktion ist für das Provisionieren ausgelegt
function Remove-SPProvisioning_AllSiteColumnsFromContentTypesFromProvisioning
{
	<# 
	.SYNOPSIS
    Entfernt alle SiteColumns am ContentTypes
    .DESCRIPTION
    Es werden alle ContentTypes und alle SiteColumns geladen. Dann wird gepr�ft ob am ContentType einer der SiteColumn enthalten ist, 
	wenn ja wird dieser vom ContentType entfernt.
    .PARAMETER WebContent 
    der XML Knoten mit den WebContents
	#>
	[CmdletBinding()]
	param(
	[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
	[ValidateNotNullOrEmpty()]
    $WebContent 
	)
	begin
	{
		Write-Verbose "RemoveSiteColumnsFromContentTypes begin"
	}
	process
	{
		$ct = $WebContent.ContentTypes.ContentType
		$sc = $WebContent.SiteColumns.SiteColumn

		Write-Host "START RemoveSiteColumnsFromContentTypes"

		$web = $Global:CurrentWeb
		$web.Context.Load($web.AvailableContentTypes)
		$web.Context.ExecuteQuery()
    
		foreach($contentType in $web.AvailableContentTypes)
		{
			if($ct.InternalName -contains $contentType.Name)
			{
				Write-Host "Removing site columns from Content Type $($contentType.Name)"

				$contentType.Context.Load($contentType.Fields)
				$contentType.Context.Load($contentType.FieldLinks)
				$contentType.Context.ExecuteQuery()
        
				for ($j = 0; $j -lt $contentType.Fields.Count; $j++) 
				{
					$field = $contentType.Fields[$j]

					$xmlField = $sc | Where-Object { $_.InternalName -eq $field.InternalName }

					if($xmlField)
					{
						if($xmlField.DependentColumn)
						{
							$xmlFieldDependet = $sc | Where-Object { $_.InternalName -eq $xmlField.DependentColumn }
							$fieldLinkDependet = $contentType.FieldLinks | Where-Object { $_.Name -eq $xmlFieldDependet.InternalName }
						
							if($fieldLinkDependet) 
							{
								$nameDependet = $fieldLinkDependet.Name
								$fieldLinkDependet.DeleteObject()
								$contentType.Update($true);
								$contentType.Context.ExecuteQuery()
								Write-Host "Removed Dependent Site Column $($nameDependet)" -Type success
							}
							else 
							{
								throw "Error to Delete the Dependet FieldLinks $($xmlFieldDependet.InternalName)"
							}
						}

						$fieldLink = $contentType.FieldLinks | Where-Object { $_.Id -eq $field.Id }
                    
						if($fieldLink)
						{
							$fieldLink.DeleteObject()
							$contentType.Update($true);
							$contentType.Context.ExecuteQuery()
							Write-Host "Removed Site Column $($field.InternalName)" -Type success
						}
						else 
						{
							Write-Host "Error to Delete the FieldLinks $($field.InternalName)" -Type error
						}
					}
				}
			}
		} 
	}
	end
	{
		Write-Verbose "RemoveSiteColumnsFromContentTypes end"
	}
}
