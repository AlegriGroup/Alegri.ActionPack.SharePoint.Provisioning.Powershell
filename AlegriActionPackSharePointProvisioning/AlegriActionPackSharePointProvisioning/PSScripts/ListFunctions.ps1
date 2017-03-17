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