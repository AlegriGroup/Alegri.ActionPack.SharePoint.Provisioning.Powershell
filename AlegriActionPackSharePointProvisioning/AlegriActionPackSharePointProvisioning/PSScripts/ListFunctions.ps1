#
# ListFunctions.ps1
#

function Start-AP_SPProvisioning_RemovedListCorrectly
{
	<#
	.Synopsis
	Start AP_SPProvisioning_RemovedListCorrectly
	.DESCRIPTION
	The Start for the Action AP_SPProvisioning_RemovedListCorrectly
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
		Write-Verbose "Start Start-AP_SPProvisioning_RemovedListCorrectly"
    }
    Process
    {	
		$pathToXML = Use-AP_SPProvisioning_SPEnvironment_Check-ReplaceProjectPath -path $xmlActionObject.pathToProvisioningXML

		if($xmlActionObject.ListName){
			$lists = @()
			$lists = $xmlActionObject.ListName
		} else {
			
			$lists = Get-AP_SPProvisioning_GetListTitleFromXML -pathToProvisioningXML $pathToXML
		}
		
		$contentTypes = Get-AP_SPProvisioning_GetContentTypeNameFromXML -pathToProvisioningXML $pathToXML
		$siteColumns = Get-AP_SPProvisioning_GetSiteColumngNameFromXML -pathToProvisioningXML $pathToXML

		if($lists.Count -gt 0) 
		{
			# ------------------------
			# Workflows from lists
			# ------------------------
			#RemoveWorkflows
			#Write-Host "Successfully removed workflows from lists" -Type success
			#Write-Host

			# ------------------------
			# Content Types from Lists
			# ------------------------    
			Remove-ContentTypesFromListsCorrectly -arrayLists $lists -arrayContentType $contentTypes 
			Write-Host "Successfully removed content types from list" 
			Write-Host
    
			# ------------------------
			# Fields from Lists
			# ------------------------
			Remove-FieldsFromListsCorrectly -arrayLists $lists -arraySiteColumn $siteColumns
			Write-Host "Successfully removed fields from lists" 
			Write-Host

			# ------------------------
			# Lists from Web
			# ------------------------
			Remove-ListsFromWeb -arrayLists $lists
			Write-Host "Successfully removed lists from web"
			Write-Host
		}
		else
		{
			Write-Host "Removed List Correctly wird übergangen"
		}
    }
    End
    {
		Write-Verbose "End Start-AP_SPProvisioning_RemovedListCorrectly"
    }
}

function Start-AP_SPProvisioning_RemoveContentTypFromListItems
{
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=0)]
        [System.Xml.XmlLinkedNode]$xmlActionObject
	)

    Begin
    {
        Write-Verbose "Remove-ListsFromWeb begin"
    }

    Process
    {
		  $currentWeb = Get-AP_SPProvisioning_SPEnvironment_CurrentWeb
          $listname = $xmlActionObject.ListName
		  $list = Use-AP_SPProvisioning_PnP_Get-PnPList -Web $currentWeb.Web -Identity $listname 
		  
		  if($list)
		  {
			  Remove-ContentTypFromListItems -list $list -currentWeb $currentWeb
		  } else {
			  Write-Host "Liste $($listname) are not founded"
		  }		  
    }

    End
    {
		Write-Verbose "Remove-ListsFromWeb begin"
    }
}

function Start-AP_SPProvisioning_GetListContentsToCSV
{
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=0)]
        [System.Xml.XmlLinkedNode]$xmlActionObject
	)

    Begin
    {
        Write-Verbose "Start-AP_SPProvisioning_GetListContentsToCSV Begin"
    }
    Process
    {
		  $path = Use-AP_SPProvisioning_SPEnvironment_Check-ReplaceProjectPath -path $xmlActionObject.OutputFile;
		  Get-ListContentsToCSV -columns $xmlActionObject.Column -ListName $xmlActionObject.ListName -FileName $path
	}
    End
    {
		Write-Verbose "Start-AP_SPProvisioning_GetListContentsToCSV End"
    }
}

function Start-AP_SPProvisioning_AddListContentsFromCSV
{
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=0)]
        [System.Xml.XmlLinkedNode]$xmlActionObject
	)

    Begin
    {
        Write-Verbose "Start-AP_SPProvisioning_AddListContentsFromCSV Begin"
    }
    Process
    {
		  $path = Use-AP_SPProvisioning_SPEnvironment_Check-ReplaceProjectPath -path $xmlActionObject.PathToCsv;
		  $content = Get-Content $path -Encoding String
		  Add-ALG_ListContents -contentCsv $content -Listname $xmlActionObject.ListName
          #$listname = $xmlActionObject.ListName
	}
    End
    {
		Write-Verbose "Start-AP_SPProvisioning_AddListContentsFromCSV End"
    }
}

function Remove-ListsFromWeb
{
	<# 
	.SYNOPSIS
    Entfernt die Liste vom SharePoint
    .DESCRIPTION
    Es werden alle übergebene Liste vom SharePoint gelöscht
    .PARAMETER arrayLists 
    Alle Listen die gelöscht werden sollen
	#>
	[CmdletBinding()]
	param(
	[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
	[ValidateNotNullOrEmpty()]
    $arrayLists 
	)
	begin
	{
		Write-Verbose "Remove-ListsFromWeb begin"
	}
	process
	{
		Write-Host "START Remove-ListsFromWeb"

		foreach($liste in $arrayLists)
		{        
			$currentWeb = Get-AP_SPProvisioning_SPEnvironment_CurrentWeb

			Use-AP_SPProvisioning_PnP_Remove-PnPList -Identity $liste -Web $currentWeb.Web -Force $true;
			
			Write-Host "Removed List $liste"
		} 
	}
	end
	{
		Write-Verbose "Remove-ListsFromWeb end"
	}     
}

function Remove-ContentTypFromListItems
{
	param
	(
		$list,
		$currentWeb
	)
	begin
	{
		Write-Verbose "Remove-ContentTypFromListItems begin"
	}
	process
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
							
			Write-Host "Change ContentType on Item"
		}
						
		
	}
	end
	{
		Write-Verbose "Remove-ContentTypFromListItems end"
	}  
}

function Get-ListContentsToCSV
{
	<# 
	.SYNOPSIS
    Installation der Umgebung	
    .DESCRIPTION
    Es wird auf Grundlage des SubSite Knoten die Anwendung auf der verbundenen Umgebung installiert
    .PARAMETER SitesXmlKnoten 
    Der XML Knoten der Site
    Es muss vom Schema http://schemas.sharePoint.Provisioning.alegri.eu sein.   
	#>
	[CmdletBinding()]
	param(
		[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
		[System.Array]$columns,
		[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
		[ValidateNotNullOrEmpty()]
		[string]$ListName,
		[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
		[ValidateNotNullOrEmpty()]
		[string]$FileName
	)
	begin
	{
		Write-Verbose "Get-ListContentsToCSV begin"
	}
	process
	{
		[System.Collections.ArrayList]$dataArray = New-Object System.Collections.ArrayList;
		$itemString = "";
		$currentWeb = Get-AP_SPProvisioning_SPEnvironment_CurrentWeb

		#1. Spalte die Columns
		for($i = 0; $i -lt $columns.Count; $i++)
        {
			if($i -gt 0){ $itemString += ";" }

			$itemString += 	$columns[$i].ColumnInternalName
		}
		$dataArray.Add($itemString);

        #2 nun die Werte
		$items = Use-AP_SPProvisioning_PnP_Get-PnPListItem -List $ListName -Web $currentWeb.Web

		Write-Host "Es werden $($items.Count) Items aufbereitet"

        foreach($item in $items)   
		{
			$itemString = "";
			for($i = 0; $i -lt $columns.Count; $i++)
			{
				if($i -gt 0){ $itemString += ";" }
                
                $value = $item[$columns[$i].ColumnInternalName]
                
                switch($value)
                {
                    "Microsoft.SharePoint.Client.FieldLookupValue" { $itemString += $item[$columns[$i].ColumnInternalName].LookupId }
                    default { $itemString +=  $value }
                } 
            }

			$dataArray.Add($itemString);
        }

        $dataArray | Set-Content -Path $FileName -Force
	}
	end
	{
		Write-Verbose "Get-ListContentsToCSV end"
	}
}

function Add-ALG_ListContents
{
	<# 
	.SYNOPSIS
    Installation der Umgebung	
    .DESCRIPTION
    Es wird auf Grundlage des SubSite Knoten die Anwendung auf der verbundenen Umgebung installiert
    .PARAMETER SitesXmlKnoten 
    Der XML Knoten der Site
    Es muss vom Schema http://schemas.sharePoint.Provisioning.alegri.eu sein.   
	#>
	[CmdletBinding()]
	param(
		[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [System.Array]$contentCsv,
		[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [string]$Listname
	)
	begin
	{
		Write-Verbose "Add-ALG_ListContents begin"
	}
	process
	{
		$currentWeb = Get-AP_SPProvisioning_SPEnvironment_CurrentWeb
		#1.Column Field with InternalName
		$columns = $contentCsv[0].Split(";");
				
		#iterate all Items
		for ($j = 1; $j -lt $contentCsv.Count; $j++) 
        {
			$values = $contentCsv[$j].Split(";");
			
			$valueString = @{}
			
			for($i = 0; $i -lt $columns.Count;$i++)
			{
				$valueString.Add($columns[$i] ,$values[$i])				
			}
			
			Use-AP_SPProvisioning_PnP_Add-PnPListItem -List $Listname -Values $valueString -Web $currentWeb.Web
			
			Write-Host "Item $($j) from $($contentCsv.Count) are create"
		}
	}
	end
	{
		Write-Verbose "Add-ALG_ListContents end"
	}
}