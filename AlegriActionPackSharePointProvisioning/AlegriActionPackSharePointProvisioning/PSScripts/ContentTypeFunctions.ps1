#
# ContentTypeFunctions.ps1
#

function Start-AP_SPProvisioning_RemovedContentType
{
	<#
	.Synopsis
	Start AP_SPProvisioning_RemovedContentType
	.DESCRIPTION
	The Start for the Action AP_SPProvisioning_RemovedContentType
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
		Write-Verbose "Start Start-AP_SPProvisioning_RemovedContentType"
    }
    Process
    {	
		$name = $null;
		$group_name = $null;
		$currentWeb = Get-AP_SPProvisioning_SPEnvironment_CurrentWeb

		if($xmlActionObject.Name) { $name = $xmlActionObject.Name}
		if($xmlActionObject.GroupName) { $group_name = $xmlActionObject.GroupName}

		if($name -eq $null -and $group_name -eq $null)
		{
			Write-Error "Missing attributes. At least one of the attributes [Name or GroupName] must be passed"
		} 
		else 
		{
			Select-AP_SPProvisioning_ContentType -Web $currentWeb.Web -Name $name -GroupName $group_name
		}
    }
    End
    {
		Write-Verbose "End Start-AP_SPProvisioning_RemovedContentType"
    }
}

function Select-AP_SPProvisioning_ContentType
{
	<# 
	.SYNOPSIS
	Checks whether a ContentType or Groups should be deleted
	Pr�ft ob ein ContentType oder Gruppen gel�scht werden sollen
    .DESCRIPTION
	If you have specified a Name, it is deleted. If you specify a group name, all ContentTypes in the group will be removed and the Name will be passed if it is also present.
    Wenn Sie einen Name angegeben haben, wird dieser gel�scht. Wenn Sie eine Gruppenamen angeben, werde alle ContentType in der Gruppe entfernt und der Name wird �bergangen, sollte dieser ebenfalls vorhanden sein.
	.PARAMETER Web
	The Current Web Object 
	Das Aktuelle Web Objekt
	.PARAMETER Name
	The name of the ContentType to remove
    Den Namen des ContentType das entfernt werden soll
	.PARAMETER GroupName
	The group names of the ContentTypes to be removed.
    Den Gruppennamen der ContentTypes die entfernt werden sollen. 
	#>
	[CmdletBinding()]
	param(
		[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
		[ValidateNotNullOrEmpty()]
		$Web,
		$Name,
		$GroupName
	)
	begin
	{
		Write-Verbose "Remove-AP_SPProvisioning_ContentType begin"
	}
	process
	{
		if($GroupName -ne $null)
		{
			Remove-SPProvisioning_AllContentTypeFromGroup -Groupname $GroupName -Web $Web

			Write-Host "Successfully removed Content Types from the group $($GroupName) on current web" -Type success
			Write-Host
		} 
		elseif ($Name -ne $null)
		{
			Use-AP_SPProvisioning_PnP_Remove-PnPContentType -Identity $Name -Web $Web -Force $true
			Write-Host "Successfully removed Content Type from $($Name) on current web" -Type success
			Write-Host
		}
		else
		{
			Write-Error "Missing attributes. At least one of the attributes [Name or GroupName] must be passed"
		}				
	}
	end
	{
		Write-Verbose "Remove-AP_SPProvisioning_ContentType end"
	}
}

function Remove-SPProvisioning_AllContentTypeFromGroup
{
	<# 
	.SYNOPSIS
	Removes all ContentType belonging to the group
	Entfernt alle ContentType die der Gruppe angeh�ren	
    .DESCRIPTION
	Removes all ContentType belonging to the group
    Entfernt alle ContentType die der Gruppe angeh�ren
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
		Write-Verbose "Remove-SPProvisioning_AllContentTypeFromGroup begin"
	}
	process
	{
		Write-Host "START RemoveContentType from Group $($Groupname)"

		$contentTypes = Use-AP_SPProvisioning_PnP_Get-PnPContentType -Web $Web | ? { $_.Group -eq $Groupname } | Sort-Object ID -Descending
					
		if($contentTypes -eq $null)
		{
			Write-Host "There is no ContentType in the group to delete" -ForegroundColor Yellow
		}
		else 
		{
			foreach($contentType in $contentTypes)
			{
				Write-Host "Start Remove ContentType $($contentType.Name)"
				Use-AP_SPProvisioning_PnP_Remove-PnPContentType -Identity $contentType -Web $Web -Force $true
			}				
		}

		Write-Host "END RemoveContentType from Group $($Groupname)"
	}
	end
	{
		Write-Verbose "Remove-SPProvisioning_AllContentTypeFromGroup end"
	}
}

function Remove-ContentTypesFromListsCorrectly
{
	<# 
	.SYNOPSIS
    Entfert alle ContentTypes von der Liste
    .DESCRIPTION
    Es werden bei allen übergebenen Listen geprüft ob der ContentType eine vom Projekt angelegt wurde,
	wenn ja wird auf dieser Liste ein StandardContentType hinterlegt und den im Projekt verwendete ContentType
	wird entfernt.
	.PARAMETER arrayLists
	Alle Listen die bereinigt werden sollen
	.PARAMETER arrayContentType
	Alle ContentType die vom Projekt angelegt wurden
	#>
	[CmdletBinding()]
	param(
	[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
    $arrayLists,
	[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
    $arrayContentType
	)
	begin
	{
		Write-Verbose "Remove-ContentTypesFromLists begin"
	}
	process
	{
		Write-Host "START Remove-ContentTypesFromLists"

		foreach($liste in $arrayLists)
		{
			Write-Host "Removing content tyes from List $liste"
            
			$currentWeb = Get-AP_SPProvisioning_SPEnvironment_CurrentWeb
			$list = Use-AP_SPProvisioning_PnP_Get-PnPList -Identity $liste -Web $currentWeb.Web

			if($list)
			{
				$list.Context.Load($list.ContentTypes)
				$list.Context.ExecuteQuery()

				foreach($contentType in $list.ContentTypes) 
				{
					if($arrayContentType -contains $contentType.Name)
					{
						Use-AP_SPProvisioning_PnP_Add-PnPContentTypeToList -List $list -ContentType "0x0105" -DefaultContentType $true -Web $currentWeb.Web

						$query = [Microsoft.SharePoint.Client.CamlQuery]::CreateAllItemsQuery(3000, "ID")
						$listItems = $list.GetItems( $query )
						$listItems.Context.Load($listItems)
						$listItems.Context.ExecuteQuery()
						foreach($item in $listItems) 
						{
							$item["ContentTypeId"] = "0x0105"
							$item.Update()
							$listItems.Context.ExecuteQuery()
						}
						
						Use-AP_SPProvisioning_PnP_Remove-PnPContentTypeFromList -List $list.Title -ContentType $contentType.Name -Web $currentWeb.Web
						
						Write-Host "Deleted content type $($contentType.Name) from list" -Type success
					}                
				}
			}
			else 
			{
				$text = "ERROR Deleted content type from $liste because List not found"
				Write-Host $text -Type error
				$text = $text + "Soll das Skript weiter machen?"
				Create-QuestionTask -statement $text
			}
		} 
	}
	end
	{
		Write-Verbose "Remove-ContentTypesFromLists end"
	}
}

function Add-ContentTypes
{
	<# 
	.SYNOPSIS
    Erstellt die ContentTypes auf SharePoint	
    .DESCRIPTION
    Es werden die ContentType aus der Provisionierung Konfiguration Datei geladen und 
	entsprechend den hinterlegten Attribute angelegt.
    .PARAMETER xmlFile 
    Den XML Knoten der Datei.    
	#>
	[CmdletBinding()]
	param(
		[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
		[string]$xmlFile 
	)
	begin
	{
		Write-Verbose "CreateContentTypes begin"
	}
	process
	{
		[xml]$wpXml = Get-Content "$($xmlFile)" -Encoding UTF8
		$currentWeb = Get-AP_SPProvisioning_SPEnvironment_CurrentWeb
		$XMLcontentTypes = $wpXml.Provisioning.Templates.ProvisioningTemplate.ContentTypes.ContentType
        
        $fields = $currentWeb.Web.Fields
        $currentWeb.Web.Context.Load($fields)
        $currentWeb.Web.Context.executeQuery()

		foreach($XMLcontentType in $XMLcontentTypes)
		{
			#variables that needs to be set before starting the script
			$contentTypeGroup = $XMLcontentType.Group
			$contentTypeName = $XMLcontentType.Name
			$contentTypeId = $XMLcontentType.ID
			$contentTypeDescription = $XMLcontentType.Description
			$columns = $XMLcontentType.FieldRefs.FieldRef

			# Creating client context object        
			$contentTypes = $currentWeb.Web.ContentTypes
			$contentTypes.Context.Load($contentTypes)

			# send the request containing all operations to the server
			try{
				$contentTypes.Context.executeQuery()
				write-host "info: Loaded Fields and Content Types" -foregroundcolor green
			}
			catch{
				write-host "info: $($_.Exception.Message)" -foregroundcolor red
			}

			# Loop through all content types to verify it doesn't exist
			$checkContentType = $contentTypes | Where-Object { $_.Name -eq $contentTypeName}
			if($checkContentType){        
				write-host "Info: The content type $($contentTypeName) already exists." -foregroundcolor red
				$contentTypeExists = $true
			}
			else{
				$contentTypeExists = $false
			}
        
			# create content type if it doesnt exist based on specified Content Type ID
			if($contentTypeExists -eq $false){
            
				$ct = Use-AP_SPProvisioning_PnP_Add-PnPContentType -contentTypeName $contentTypeName -contentTypeId $contentTypeId -contentTypeDescription $contentTypeDescription -contentTypeGroup $contentTypeGroup -Web $currentWeb.Web
				write-host "info: create contentType $($ct.Name)" -foregroundcolor green                    
            
				# loop through all the columns that needs to be added
				foreach ($column in $columns)
				{               
					$hidden = $false;
					$require = $false;				
					if($column.Hidden -eq "true") { $hidden = $true; }				           
					if($column.Required -eq "true") { $require = $true; }

					Use-AP_SPProvisioning_PnP_Add-PnPFieldFromContentType -Field $column.Name -contentTypeId $contentTypeId -Required $require -Hidden $hidden -Web $currentWeb.Web					
                                
					write-host "info: added $($column.Name) to $($ct.Name)" -foregroundcolor green
				}                    
			}
		}
	}
	end
	{
		Write-Verbose "CreateContentTypes end"
	}
}