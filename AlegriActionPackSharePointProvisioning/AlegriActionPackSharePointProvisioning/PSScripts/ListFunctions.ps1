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
		$lists = Get-AP_SPProvisioning_GetListTitleFromXML -pathToProvisioningXML $pathToXML
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
			Write-Host "Successfully removed content types from lits" -Type success
			Write-Host
    
			# ------------------------
			# Fields from Lists
			# ------------------------
			Remove-FieldsFromListsCorrectly -arrayLists $lists -arraySiteColumn $siteColumns
			Write-Host "Successfully removed fields from lists" -Type success
			Write-Host

			# ------------------------
			# Lists from Web
			# ------------------------
			Remove-ListsFromWeb -arrayLists $lists
			Write-Host "Successfully removed lists from web" -Type success
			Write-Host
		}
		else
		{
			Write-Host "Removed List Correctly wird �bergangen"
		}
    }
    End
    {
		Write-Verbose "End Start-AP_SPProvisioning_RemovedListCorrectly"
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